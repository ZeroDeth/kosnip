# bot-preset.nix - Standardized bot configuration
#
# All bots inherit from this preset. No exceptions.
#
# STANDARD PATHS (same for all bots):
#   - State: /var/lib/openclaw
#   - Workspace: /var/lib/openclaw/workspace
#   - Config: /var/lib/openclaw/openclaw.json
#   - Logs: /tmp/openclaw/openclaw-gateway.log
#   - Secrets: /run/secrets/openclaw-env
#
# DOPPLER CONFIGURATION:
#   - DOPPLER_ENVIRONMENT (env)
#   - DOPPLER_PROJECT (env)
#   - DOPPLER_CONFIG (env)
#
# FIRST-PARTY PLUGINS (enabled by default):
#   - sag (TTS)
#
# USAGE:
#   { config, pkgs, ... }:
#   {
#     imports = [ ./bot-preset.nix ];
#     bot = {
#       name = "black";
#       owner = "zerodeth";
#       project = "black";
#       enablePlugins = [ "sag" ];
#     };
#   }

{ config, lib, pkgs, ... }:

let
  botCfg = config.bot;
in
{
  options.bot = {
    enable = lib.mkEnableOption "Standardized bot configuration";

    name = lib.mkOption {
      type = lib.types.str;
      description = "Bot hostname (e.g., black, green, pink)";
    };

    owner = lib.mkOption {
      type = lib.types.str;
      description = "Bot owner username";
      default = "zerodeth";
    };

    project = lib.mkOption {
      type = lib.types.str;
      description = "Doppler project name";
    };

    environment = lib.mkOption {
      type = lib.types.str;
      description = "Doppler environment";
      default = "dev";
    };

    enablePlugins = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "First-party plugins to enable";
      default = [ "sag" ];
    };
  };

  config = lib.mkIf botCfg.enable {
    # === BOOT ===
    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    # === NETWORKING ===
    networking = {
      firewall.enable = false;
      hostName = botCfg.name;
    };

    i18n.defaultLocale = "en_GB.UTF-8";
    services.xserver.enable = false;

    # === SSH (Tailscale) ===
    services.openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
      settings.PermitRootLogin = "yes";
    };

    # === TAILSCALE ===
    services.tailscale = {
      enable = true;
      usePredictableInterfaceNames = true;
    };

    # === OPENCLAW ===
    programs.openclaw = {
      enable = true;
      systemd.enable = true;
      stateDir = "/var/lib/openclaw";
      workspaceDir = "/var/lib/openclaw/workspace";
      
      firstParty = {
        sag.enable = lib.elem "sag" botCfg.enablePlugins;
      };
    };

    # === DOPPLER ===
    programs.doppler = {
      enable = true;
      json = true;
    };

    # === SYSTEMD SERVICE ===
    systemd.services.openclaw-${botCfg.name} = {
      description = "OpenClaw ${botCfg.name} - ${botCfg.owner}'s bot";
      after = [ "network.target" "doppler.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "notify";
        ExecStart = "${pkgs.openclaw}/bin/openclaw gateway";
        WorkingDirectory = "/var/lib/openclaw";
        Restart = "always";
        RestartSec = "10s";
        Environment = [
          "DOPPLER_ENVIRONMENT=${botCfg.environment}"
          "DOPPLER_PROJECT=${botCfg.project}"
          "DOPPLER_CONFIG=${botCfg.environment}"
        ];
        EnvironmentFile = "/run/secrets/openclaw-env";
      };
    };

    # === DIRECTORIES ===
    systemd.tmpfiles.rules = [
      "d /var/lib/openclaw 0755 root root -"
      "d /var/lib/openclaw/workspace 0755 root root -"
      "d /tmp/openclaw 0755 root root -"
      "d /run/secrets 0755 root root -"
    ];

    # === USER ===
    users.users.${botCfg.owner} = {
      isNormalUser = true;
      description = botCfg.owner;
      extraGroups = [ "networkmanager" "wheel" "tailscale" ];
    };

    # === PACKAGES ===
    environment.systemPackages = with pkgs; [
      tailscale
      git
      doppler
    ];
  };
}

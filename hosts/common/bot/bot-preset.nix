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
#   - DOPPLER_WORKSPACE = "claw"
#   - DOPPLER_PROJECT = "{name}-claw"
#   - DOPPLER_ENVIRONMENT = "dev_{name}"
#   - DOPPLER_CONFIG = "dev_{name}"
#
# USER/HOST NAMING:
#   - User: {name} (e.g., black, green, pink)
#   - Host: {name}
#   - SSH/GPG keys: {name}-claw
#
# FIRST-PARTY PLUGINS (enabled by default):
#   - sag (TTS)
#
# USAGE:
#   { config, pkgs, ... }:
#   {
#     imports = [ ./bot-preset.nix ];
#     bot = {
#       enable = true;
#       name = "black";
#       owner = "clawzero";
#       project = "black-claw";
#       environment = "dev_black";
#       enablePlugins = [ "sag" ];
#     };
#   }

{ config, lib, pkgs, ... }:

let
  botCfg = config.bot;
  userName = botCfg.name;  # User matches hostname
in
{
  options.bot = {
    enable = lib.mkEnableOption "Standardized bot configuration";

    name = lib.mkOption {
      type = lib.types.str;
      description = "Bot/machine hostname (e.g., black, green, pink)";
    };

    owner = lib.mkOption {
      type = lib.types.str;
      description = "GitHub owner (clawzero)";
      default = "clawzero";
    };

    project = lib.mkOption {
      type = lib.types.str;
      description = "Doppler project name ({name}-claw)";
    };

    environment = lib.mkOption {
      type = lib.types.str;
      description = "Doppler environment (dev_{name})";
    };

    enablePlugins = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "First-party plugins to enable";
      default = [ "sag" ];
    };
  };

  config = lib.mkIf botCfg.enable {
    # === HOSTNAME ===
    networking.hostName = botCfg.name;

    # === USER (matches hostname) ===
    users.users.${userName} = {
      isNormalUser = true;
      description = botCfg.owner;
      extraGroups = [ "networkmanager" "wheel" "tailscale" ];
      openssh.authorizedKeys.keys = [
        # SSH key pulled from GitHub during setup
        # https://github.com/clawzero/dotfiles/raw/main/keys/${botCfg.name}-claw/id_ed25519.pub
      ];
    };

    # === BOOT ===
    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
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
          "DOPPLER_WORKSPACE=claw"
          "DOPPLER_PROJECT=${botCfg.project}"
          "DOPPLER_ENVIRONMENT=${botCfg.environment}"
          "DOPPLER_CONFIG=${botCfg.environment}"
        ];
        EnvironmentFile = "/run/secrets/openclaw-env";
      };
    };

    # === DIRECTORIES ===
    systemd.tmpfiles.rules = [
      "d /var/lib/openclaw 0755 ${userName} ${userName} -"
      "d /var/lib/openclaw/workspace 0755 ${userName} ${userName} -"
      "d /tmp/openclaw 0755 ${userName} ${userName} -"
      "d /run/secrets 0755 root root -"
    ];

    # === PACKAGES ===
    environment.systemPackages = with pkgs; [
      tailscale
      git
      doppler
    ];
  };
}

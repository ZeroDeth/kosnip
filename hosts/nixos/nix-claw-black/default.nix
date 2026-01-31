# nix-claw-black: Sherif's personal AI bot (OpenClaw)
# Following nix-openclaw official patterns
#
# Standard paths (same across all bots):
#   - State: /var/lib/openclaw
#   - Workspace: /var/lib/openclaw/workspace
#   - Config: /var/lib/openclaw/openclaw.json
#   - Logs: /tmp/openclaw/openclaw-gateway.log
#
# Secrets: Doppler (runtime environment variables)

{ pkgs, unstablePkgs, inputs, ... }:

{
  imports = [
    ./../common/nixos.nix
    ./../common/packages.nix
  ];

  # Boot configuration
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Network configuration
  networking = {
    firewall.enable = false;
    hostName = "black";
    # Tailscale will handle networking
  };

  # Timezone
  i18n.defaultLocale = "en_GB.UTF-8";

  # Disable X server
  services.xserver.enable = false;

  # SSH (via Tailscale)
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.PermitRootLogin = "yes";
  };

  # Tailscale mesh networking
  services.tailscale = {
    enable = true;
    usePredictableInterfaceNames = true;
  };

  # OpenClaw via nix-openclaw (not Docker)
  programs.openclaw = {
    enable = true;
    systemd.enable = true;
    
    # Standard paths (same across all bots)
    stateDir = "/var/lib/openclaw";
    workspaceDir = "/var/lib/openclaw/workspace";
    
    # First-party plugins
    firstParty = {
      sag.enable = true;  # TTS
    };
    
    # Bot configuration (per-environment via Doppler)
    config = {
      # Config loaded from Doppler at runtime
    };
  };

  # Doppler integration
  # Doppler provides secrets via environment variables
  programs.doppler = {
    enable = true;
    json = true;
  };

  # Systemd service for OpenClaw with Doppler environment
  # Doppler secrets injected at runtime
  systemd.services.openclaw-black = {
    description = "OpenClaw Black - Sherif's personal AI";
    after = [ "network.target" "doppler.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "notify";
      ExecStart = "${pkgs.openclaw}/bin/openclaw gateway";
      WorkingDirectory = "/var/lib/openclaw";
      Restart = "always";
      RestartSec = "10s";
      # Doppler environment variables
      Environment = [
        "DOPPLER_ENVIRONMENT=dev"
        "DOPPLER_PROJECT=black"
        "DOPPLER_CONFIG=dev"
      ];
      # EnvironmentFile from Doppler secrets
      EnvironmentFile = "/run/secrets/openclaw-env";
    };
  };

  # Generate Doppler secrets file
  # This is a template - actual values come from Doppler at runtime
  systemd.tmpfiles.rules = [
    "d /run/secrets 0755 root root -"
    "f /run/secrets/openclaw-env 0600 root root -"
  ];

  # User configuration
  users.users.zerodeth = {
    isNormalUser = true;
    description = "zerodeth";
    extraGroups = [ "networkmanager" "wheel" "tailscale" ];
  };

  # Ensure directories exist
  systemd.tmpfiles.rules = [
    "d /var/lib/openclaw 0755 root root -"
    "d /var/lib/openclaw/workspace 0755 root root -"
    "d /tmp/openclaw 0755 root root -"
    "d /run/secrets 0755 root root -"
  ];

  # Packages
  environment.systemPackages = with pkgs; [
    tailscale
    git
    doppler
  ];
}

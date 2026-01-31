# nix-claw-black: Sherif's personal AI bot (OpenClaw)
# Following nix-openclaw official patterns
#
# Standard paths (same across all bots):
#   - State: ~/.openclaw
#   - Workspace: ~/.openclaw/workspace
#   - Config: ~/.openclaw/openclaw.json
#   - Logs: /tmp/openclaw/openclaw-gateway.log
#
# Secrets: Doppler (environment variables at runtime)

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
  # Uses nix-openclaw home-manager module
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
    
    # Bot configuration
    config = {
      # Channel will be configured per-environment via Doppler
    };
  };

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
  ];

  # Packages
  environment.systemPackages = with pkgs; [
    tailscale
    git
  ];
}

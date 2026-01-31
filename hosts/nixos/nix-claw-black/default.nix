# nix-claw-black: Sherif's personal AI bot (OpenClaw)
# Integrates OpenClaw + Tailscale + Doppler + Docker
{ pkgs, unstablePkgs, ... }:

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

  # Docker for OpenClaw
  virtualisation.docker = {
    enable = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
      flags = [ "--all" ];
    };
  };

  # OpenClaw bot service
  # Runs as Docker container via docker-compose
  systemd.services.openclaw-black = {
    description = "OpenClaw Black - Sherif's personal AI";
    after = [ "network.target" "docker.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.docker-compose}/bin/docker-compose up -d";
      ExecStop = "${pkgs.docker-compose}/bin/docker-compose down";
      WorkingDirectory = "/opt/openclaw-black";
    };
  };

  # Ensure /opt/openclaw-black exists
  systemd.tmpfiles.rules = [
    "d /opt/openclaw-black 0755 root root -"
  ];

  # User configuration
  users.users.zerodeth = {
    isNormalUser = true;
    description = "zerodeth";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
  };

  # Environment variables for Doppler
  environment.sessionVariables = {
    DOPPLER_ENVIRONMENT = "dev";
    DOPPLER_PROJECT = "black";
  };

  # Packages
  environment.systemPackages = with pkgs; [
    docker-compose
    tailscale
    git
  ];
}

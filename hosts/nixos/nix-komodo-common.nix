# Common configuration for all nix-komodo hosts
{ config, pkgs, lib, ... }:

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

  # Common network configuration for Komodo hosts
  networking = {
    firewall.enable = false;
    defaultGateway = "192.168.10.1";
    nameservers = [ "192.168.10.1" ];
  };

  # System localization
  # Note: time.timeZone is already defined in nixos-common.nix
  i18n.defaultLocale = "en_GB.UTF-8";

  services.xserver = {
    enable = false;
  };

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
    settings.PermitRootLogin = "yes";
  };
  services.tailscale.enable = true;
  # Docker Compose for Komodo deployment
  # As per memory: Using Docker Compose via ironicbadger.docker-compose-generator
  # for MongoDB, Komodo Core, and Komodo Periphery
  virtualisation.oci-containers.backend = "docker";

  # userland
  #home-manager.useGlobalPkgs = true;
  #home-manager.useUserPackages = true;
  #home-manager.users.zerodeth = { imports = [ ./../../home/zerodeth.nix ]; };
  users.users.zerodeth = {
    isNormalUser = true;
    description = "zerodeth";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      #home-manager
    ];
  };

  # Hardware configuration
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}

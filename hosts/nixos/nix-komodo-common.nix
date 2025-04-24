# Common configuration for all nix-komodo hosts
{ config, pkgs, lib, ... }:

{
  imports = [
    ./../common/nixos-common.nix
    ./../common/common-packages.nix
  ];

  # Boot configuration
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Common network configuration
  networking = {
    firewall.enable = false;
    defaultGateway = "192.168.10.1";
    nameservers = [ "192.168.10.1" ];
  };

  # System localization
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_GB.UTF-8";

  services.xserver = {
    enable = false;
  };

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
    settings.PermitRootLogin = "yes";
  };
  services.qemuGuest.enable = true;
  services.tailscale.enable = true;
  # services.komodo = {
  #   enable = true;
  #   host = "0.0.0.0";
  # };

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

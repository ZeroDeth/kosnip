{ config, inputs, pkgs, name, lib, ... }:

{
  imports =
    [
      # hardware-configuration.nix is now imported directly in helpers.nix
      ./../../common/nixos.nix
      ./../../common/packages.nix
    ];

  # Boot configuration
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Network configuration
  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 80 81 443 ]; # SSH, HTTP, NPM admin, HTTPS
    };
    hostName = "nix-npm";
    interfaces.ens18 = {
      useDHCP = false;
      ipv4.addresses = [{
        address = "192.168.10.5";
        prefixLength = 24;
      }];
    };
    defaultGateway = "192.168.10.1";
    nameservers = [ "192.168.10.1" ];
  };

  # System localization
  # Note: time.timeZone is already defined in nixos-common.nix
  i18n.defaultLocale = "en_GB.UTF-8";

  services.xserver = {
    enable = false;
    # videoDrivers = [ "nvidia" ];
  };

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
    settings.PermitRootLogin = "yes";
  };
  services.tailscale.enable = true;

  # userland
  #home-manager.useGlobalPkgs = true;
  #home-manager.useUserPackages = true;
  #home-manager.users.zerodeth = { imports = [ ./../../../home/zerodeth.nix ]; };
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
      enable = false;
      enable32Bit = false;
    };
    nvidia = {
      modesetting.enable = false;
      open = false;
      nvidiaSettings = false;
      powerManagement.enable = false;
    };
    nvidia-container-toolkit.enable = false;
  };

}

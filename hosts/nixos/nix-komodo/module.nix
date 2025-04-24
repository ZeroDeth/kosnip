{ config, inputs, pkgs, name, lib, hostname, ... }:

let
  # Extract the numeric suffix from the hostname (e.g., "nix-komodo-01" -> "01")
  hostNumStr = lib.strings.removePrefix "nix-komodo-" hostname;
  # Convert the numeric suffix to an integer
  hostNum = lib.strings.toInt hostNumStr;
  # Calculate the last octet of the IP address (e.g., 30 + 1 = 31, 30 + 2 = 32)
  ipLastOctet = 30 + hostNum;
  # Construct the full IP address string
  ipAddress = "192.168.10.${toString ipLastOctet}";
in
{
  imports =
    [
      ./hardware-configuration.nix # Now in the same directory
      ./../../common/nixos-common.nix
      ./../../common/common-packages.nix
    ];

  # Boot configuration
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Network configuration
  networking = {
    firewall.enable = false;
    # Hostname is passed via specialArgs by mkNixos
    inherit hostname;
    interfaces.ens18 = {
      useDHCP = false;
      ipv4.addresses = [{
        address = ipAddress; # Use the calculated IP address
        prefixLength = 24;
      }];
    };
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
  #home-manager.users.zerodeth = { imports = [ ./../../../home/zerodeth.nix ]; };
  users.users.zerodeth = {
    isNormalUser = true;
    description = "zerodeth";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      #home-manager
    ];
  };

  # Hardware configuration (specifics are in hardware-configuration.nix)
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  # Set the state version
  system.stateVersion = config.system.stateVersion;
}

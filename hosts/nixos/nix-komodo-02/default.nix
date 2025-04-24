{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./../nix-komodo-common.nix
  ];

  # Host-specific network configuration
  networking = {
    hostName = "nix-komodo-02";
    interfaces.ens18 = {
      useDHCP = false;
      ipv4.addresses = [{
        address = "192.168.10.32";
        prefixLength = 24;
      }];
    };
  };
}

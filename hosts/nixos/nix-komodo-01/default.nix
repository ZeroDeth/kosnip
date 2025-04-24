{ ... }:

{
  imports = [
    # Import the common Komodo configuration
    ../nix-komodo.nix
  ];

  # Host-specific network configuration
  networking = {
    hostName = "nix-komodo-01";
    interfaces.ens18 = {
      useDHCP = false;
      ipv4.addresses = [{
        address = "192.168.10.31";
        prefixLength = 24;
      }];
    };
  };
}

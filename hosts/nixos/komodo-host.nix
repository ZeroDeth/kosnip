# Function to create a Komodo host configuration
# This allows us to parameterize host-specific settings while reusing common configuration
{ ... }:

# Function that takes hostname and IP address as parameters
{ hostname, ipAddress }:

{
  imports = [
    ./nix-komodo-common.nix
  ];

  # Host-specific network configuration
  networking = {
    hostName = hostname;
    interfaces.ens18 = {
      useDHCP = false;
      ipv4.addresses = [{
        address = ipAddress;
        prefixLength = 24;
      }];
    };
  };
}

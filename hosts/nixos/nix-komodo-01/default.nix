{ ... }:

# Import the komodo-host function and call it with host-specific parameters
import ../nix-komodo.nix { }
{
  hostname = "nix-komodo-01";
  ipAddress = "192.168.10.31";
}

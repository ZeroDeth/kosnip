{ ... }:

# Import the komodo-host function and call it with host-specific parameters
import ../komodo-host.nix { }
{
  hostname = "nix-komodo-02";
  ipAddress = "192.168.10.32";
}

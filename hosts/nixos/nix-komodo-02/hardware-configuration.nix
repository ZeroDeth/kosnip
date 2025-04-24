# Hardware configuration for nix-komodo-02
# This file imports the common hardware configuration
{ ... }:

{
  # Import the common hardware configuration
  imports = [
    ./../../common/hardware-common.nix
  ];

  # Any host-specific hardware settings can be added here
}

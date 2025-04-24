# Hardware configuration for nix-llm
# This file imports the common hardware configuration
{ ... }:

{
  # Import the common hardware configuration
  imports = [
    ./../../common/hardware-common.nix
  ];

  # Any host-specific hardware settings can be added here
}

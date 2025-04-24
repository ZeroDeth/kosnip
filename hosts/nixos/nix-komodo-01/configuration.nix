{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./../nix-komodo-common.nix
  ];

  # Add any host-specific overrides here
}

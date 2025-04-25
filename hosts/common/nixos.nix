{ pkgs, unstablePkgs, lib, inputs, ... }:
let
  inherit (inputs) nixpkgs nixpkgs-unstable;
in
{
  imports = [
    ./hardware-configuration.nix
  ];

  # Common time zone for all NixOS systems
  time.timeZone = "Europe/Berlin";
  system.stateVersion = "24.11";

  virtualisation = {
    docker = {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      warn-dirty = false;
      # 500mb buffer
      download-buffer-size = 500000000;
    };
    # Automate garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 5";
    };
  };
}

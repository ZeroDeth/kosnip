#!/bin/bash
# Install NixOS for nix-black-personal
# Usage: sh install-nix.sh nix-black-personal

# Check if the script is running as root
if [ "$EUID" -ne 0 ]; then
  echo "This script must be run as root"
  exit 1
fi

# Clone kosnip if not already present
if [ ! -d "/root/kosnip" ]; then
  git clone https://github.com/ZeroDeth/kosnip.git /root/kosnip
fi

cd /root/kosnip/hosts/nixos/nix-black-personal

# Run disko to partition and format disk
nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko ./disko.nix

# Generate nixos configuration
nixos-generate-config --no-filesystems --root /mnt

# Copy hardware configuration
cp ./hardware-configuration.nix /mnt/etc/nixos/

# Install NixOS
export NIXPKGS_ALLOW_UNFREE=1
nixos-install --root /mnt --flake .#nix-black-personal --impure

echo "Installation complete! Don't forget to set root password before rebooting."

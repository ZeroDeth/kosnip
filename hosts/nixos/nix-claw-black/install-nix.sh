#!/bin/bash
# Install NixOS for nix-claw-black
# Usage: sh install-nix.sh nix-claw-black

set -euo pipefail

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo "This script must be run as root"
  exit 1
fi

# Clone kosnip if not already present
if [ ! -d "/root/kosnip" ]; then
  git clone https://github.com/ZeroDeth/kosnip.git /root/kosnip
fi

cd /root/kosnip/hosts/nixos/nix-claw-black

# Run disko to partition and format disk
nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko ./disko.nix

# Generate nixos configuration
nixos-generate-config --no-filesystems --root /mnt

# Copy hardware configuration
cp ./hardware-configuration.nix /mnt/etc/nixos/

# Install NixOS
export NIXPKGS_ALLOW_UNFREE=1
nixos-install --root /mnt --flake .#nix-claw-black --impure

echo "Installation complete!"
echo "Before rebooting, set root password:"
echo "  nixos-enter --root /mnt"
echo "  passwd"
echo "  exit"
echo "  reboot"

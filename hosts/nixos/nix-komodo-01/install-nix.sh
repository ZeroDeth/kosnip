#!/bin/bash
# git clone -b nix-nvidia https://github.com/tailscale-dev/video-code-snippets.git
# cd video-code-snippets/2025-02-nix-nvidia-ollama/nix/hosts/nixos/nix-llm/
# Usage: sh install-nix.sh <target-hostname>
# Example: sh install-nix.sh nix-komodo-01

# Check if hostname argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <target-hostname>"
  exit 1
fi
TARGET_HOSTNAME=$1

# Check if the script is running as root
if [ "$EUID" -ne 0 ]; then
  echo "This script must be run as root"
  exit 1
fi

# disk partitioning etc
nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko disko.nix
nixos-generate-config --no-filesystems --root /mnt

# installation
export NIXPKGS_ALLOW_UNFREE=1
cp hardware-configuration.nix /mnt/etc/nixos/
# Use the specific hostname for this host
nixos-install --root /mnt --flake ".#nix-komodo-01" --impure

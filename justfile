#!/usr/bin/env -S just --justfile

## repo configuration
sub-update:
  cd .. && git submodule update --init --recursive

## nix installation
install-llm IP:
  ssh -o "StrictHostKeyChecking no" nixos@{{IP}} "sudo bash -c '\
    nix-shell -p git --run \"cd /root/ && \
    git clone -b nix-llm https://github.com/ZeroDeth/kosnip.git && \
    cd kosnip/hosts/nixos/nix-llm/ && \
    sh install-nix.sh\"'"

# Install Komodo host, requires target hostname (e.g., nix-komodo-01) and IP
install-komodo HOSTNAME IP:
  ssh -o "StrictHostKeyChecking no" nixos@{{IP}} "sudo bash -c '\
    nix-shell -p git --run \"cd /root/ && \
    rm -rf kosnip && \
    git clone https://github.com/ZeroDeth/kosnip.git && \
    cd kosnip/hosts/nixos/nix-komodo/ && \
    sh install-nix.sh {{HOSTNAME}}\"'" # Pass hostname to install script

## nix updates
hostname := `hostname | cut -d "." -f 1`
[linux]
switch-llm target_host=hostname:
  cd hosts/nixos/nix-llm && sudo nixos-rebuild switch --flake .#{{target_host}}

# Switch Komodo host, defaults to current hostname but can be overridden
switch-komodo target_host=hostname:
  cd hosts/nixos/nix-komodo && sudo nixos-rebuild switch --flake .#{{target_host}}

## copy docker compose yaml to remote host via Ansible
compose HOST *V:
  cd ansible && ansible-playbook playbook.yaml --limit {{HOST}} --tags compose {{V}}

#!/usr/bin/env -S just --justfile

# Repository configuration
sub-update:
  git submodule update --init --recursive

# NixOS installation recipes
# Each recipe installs NixOS on a remote host via SSH
# Usage: just install-<host> <IP_ADDRESS>

# Install NixOS on nix-llm host
install-llm IP:
  ssh -o "StrictHostKeyChecking no" nixos@{{IP}} "sudo bash -c '\
    nix-shell -p git --run \"cd /root/ && \
    git clone https://github.com/ZeroDeth/kosnip.git && \
    cd kosnip/hosts/nixos/nix-llm/ && \
    sh install-nix.sh nix-llm\"'"

# Install NixOS on nix-komodo-01 host
install-komodo-01 IP:
  ssh -o "StrictHostKeyChecking no" nixos@{{IP}} "sudo bash -c '\
    nix-shell -p git --run \"cd /root/ && \
    git clone https://github.com/ZeroDeth/kosnip.git && \
    cd kosnip/hosts/nixos/nix-komodo-01/ && \
    sh install-nix.sh nix-komodo-01\"'"

# Install NixOS on nix-komodo-02 host
install-komodo-02 IP:
  ssh -o "StrictHostKeyChecking no" nixos@{{IP}} "sudo bash -c '\
    nix-shell -p git --run \"cd /root/ && \
    git clone https://github.com/ZeroDeth/kosnip.git && \
    cd kosnip/hosts/nixos/nix-komodo-02/ && \
    sh install-nix.sh nix-komodo-02\"'"

# NixOS update recipes (nixos-rebuild switch)
# Each recipe updates NixOS configuration on a host
hostname := `hostname | cut -d "." -f 1`

# Update NixOS configuration on nix-llm host
switch-llm target_host=hostname:
  cd hosts/nixos/nix-llm && sudo nixos-rebuild switch --flake .#{{target_host}}

# Update NixOS configuration on nix-komodo-01 host
switch-komodo-01 target_host="nix-komodo-01":
  sudo nixos-rebuild switch --flake .#{{target_host}}

# Update NixOS configuration on nix-komodo-02 host
switch-komodo-02 target_host="nix-komodo-02":
  sudo nixos-rebuild switch --flake .#{{target_host}}

# Remote deployment recipes
# Deploy NixOS configuration to remote hosts directly

# Deploy to nix-llm from local machine (using SSH approach)
deploy-llm target_host="nix-llm":
  # Clone the repository on the remote host and build there
  ssh root@{{target_host}} "cd /root && rm -rf kosnip && git clone https://github.com/ZeroDeth/kosnip.git && cd kosnip && nixos-rebuild switch --flake .#{{target_host}}"

# Deploy to nix-komodo-01 from local machine (using SSH approach)
deploy-komodo-01 target_host="nix-komodo-01":
  # Clone the repository on the remote host and build there
  ssh root@{{target_host}} "cd /root && rm -rf kosnip && git clone https://github.com/ZeroDeth/kosnip.git && cd kosnip && nixos-rebuild switch --flake .#{{target_host}}"

# Deploy to nix-komodo-02 from local machine (using SSH approach)
deploy-komodo-02 target_host="nix-komodo-02":
  # Clone the repository on the remote host and build there
  ssh root@{{target_host}} "cd /root && rm -rf kosnip && git clone https://github.com/ZeroDeth/kosnip.git && cd kosnip && nixos-rebuild switch --flake .#{{target_host}}"

# Docker Compose deployment via Ansible
# Copies Docker Compose YAML to a remote host
compose HOST *V:
  cd ansible && ansible-playbook playbook.yaml --limit {{HOST}} --tags compose {{V}}

# Copy all configuration files to remote hosts
config-files HOST *V:
  cd ansible && ansible-playbook playbook.yaml --limit {{HOST}} --tags config_files {{V}}

# Copy LLM configuration files to remote host
llm-config HOST *V:
  cd ansible && ansible-playbook playbook.yaml --limit {{HOST}} --tags llm_config {{V}}

# Copy Komodo configuration files to remote hosts
komodo-config HOST *V:
  cd ansible && ansible-playbook playbook.yaml --limit {{HOST}} --tags komodo_config {{V}}

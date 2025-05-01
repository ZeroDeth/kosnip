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

# Install NixOS on nix-metrics host
install-metrics IP:
  ssh -o "StrictHostKeyChecking no" nixos@{{IP}} "sudo bash -c '\
    nix-shell -p git --run \"cd /root/ && \
    git clone https://github.com/ZeroDeth/kosnip.git && \
    cd kosnip/hosts/nixos/nix-metrics/ && \
    sh install-nix.sh nix-metrics\"'"

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
switch-llm target_host="nix-llm":
  cd hosts/nixos/nix-llm && sudo nixos-rebuild switch --flake .#{{target_host}}

# Update NixOS configuration on nix-metrics host
switch-metrics target_host="nix-metrics":
  cd hosts/nixos/nix-metrics && sudo nixos-rebuild switch --flake .#{{target_host}}

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

# Deploy to nix-metrics from local machine (using SSH approach)
deploy-metrics target_host="nix-metrics":
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

# Show the current NixOS system configuration on a remote host
show-config target_host="nix-llm":
  ssh root@{{target_host}} "readlink -f /run/current-system && ls -la /nix/var/nix/profiles/system* && echo '\nActive configuration files:' && find /root/kosnip -name '*.nix' | grep -v '.git'"

# Show the current NixOS system configuration settings
show-settings target_host="nix-llm":
  ssh root@{{target_host}} "nixos-rebuild dry-activate --flake /root/kosnip#{{target_host}} && echo '\nCurrent hostname:' && hostname && echo '\nNetwork configuration:' && ip addr show && echo '\nEnabled services:' && systemctl list-units --type=service --state=active | grep -v '.slice'"

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

# Copy Metrics configuration files to remote host
metrics-config HOST *V:
  cd ansible && ansible-playbook playbook.yaml --limit {{HOST}} --tags metrics_config {{V}}

# Copy Komodo configuration files to remote hosts
komodo-config HOST *V:
  cd ansible && ansible-playbook playbook.yaml --limit {{HOST}} --tags komodo_config {{V}}

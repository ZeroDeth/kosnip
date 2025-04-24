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

install-komodo-01 IP:
  ssh -o "StrictHostKeyChecking no" nixos@{{IP}} "sudo bash -c '\
    nix-shell -p git --run \"cd /root/ && \
    git clone -b nix-komodo-01 https://github.com/ZeroDeth/kosnip.git && \
    cd kosnip/hosts/nixos/nix-komodo-01/ && \
    sh install-nix.sh\"'"

install-komodo-02 IP:
  ssh -o "StrictHostKeyChecking no" nixos@{{IP}} "sudo bash -c '\
    nix-shell -p git --run \"cd /root/ && \
    git clone -b nix-komodo-02 https://github.com/ZeroDeth/kosnip.git && \
    cd kosnip/hosts/nixos/nix-komodo-02/ && \
    sh install-nix.sh\"'"

## nix updates
hostname := `hostname | cut -d "." -f 1`
[linux]
switch-llm target_host=hostname:
cd hosts/nixos/nix-llm && sudo nixos-rebuild switch --flake .#{{target_host}}

switch-komodo-01 target_host=hostname:
  cd hosts/nixos/nix-komodo-01 && sudo nixos-rebuild switch --flake .#{{target_host}}

switch-komodo-02 target_host=hostname:
  cd hosts/nixos/nix-komodo-02 && sudo nixos-rebuild switch --flake .#{{target_host}}

## copy docker compose yaml to remote host via Ansible
compose HOST *V:
cd ansible && ansible-playbook playbook.yaml --limit {{HOST}} --tags compose {{V}}

# Archived kosnip Content

This directory contains archived machine definitions that are no longer actively maintained.

## What's Here

### Hosts
- `nix-komodo-01/` - Komodo host (replaced by claw-nix)
- `nix-komodo-02/` - Komodo secondary host
- `nix-komodo.nix` - Komodo shared config
- `nix-llm/` - LLM computation host
- `nix-metrics/` - Monitoring host
- `nix-npm/` - NPM registry host

### Ansible
- `nix-komodo/` - Komodo service configs
- `nix-llm/` - LLM service configs
- `nix-metrics/` - Monitoring service configs
- `nix-npm/` - NPM registry configs

## Migration

All machines have been migrated to claw-nix pattern:
- `hosts/nixos/nix-claw-{name}/`

See [claw-nix](https://github.com/clawzero/claw-nix) for current configurations.

# Technology Stack

## Build System & Package Management

- **Nix Flakes**: Primary build and dependency management system
- **NixOS 24.11**: Base operating system with declarative configuration
- **nixpkgs-unstable**: Access to bleeding-edge packages when needed

## Infrastructure Tools

- **Just**: Task runner for deployment and management commands
- **Ansible**: Configuration management and Docker Compose deployment
- **Docker**: Container runtime with auto-pruning enabled
- **Git Submodules**: External role and module management

## Development Environment

- **VSCode Server**: Remote development support via Nix module
- **nix-ld**: Foreign binary compatibility system-wide

## Common Commands

### NixOS Management

```bash
# Build and switch configuration locally
just switch-<host> [target_host]

# Deploy to remote host
just deploy-<host> [target_host]

# Install NixOS on fresh host
just install-<host> <IP_ADDRESS>

# Show current system configuration
just show-config [target_host]
```

### Ansible Deployment

```bash
# Deploy Docker Compose services
just compose <HOST>

# Deploy specific service configurations
just llm-config <HOST>
just metrics-config <HOST>
just komodo-config <HOST>
just npm-config <HOST>

# Deploy Dockge management interface
just dockge-deploy <HOST>
```

### Repository Management

```bash
# Update git submodules
just sub-update
```

## Configuration Patterns

- All NixOS configurations use `mkNixos` helper function from `lib/helpers.nix`
- Common configuration shared via `hosts/common/nixos.nix`
- Host-specific configs in `hosts/nixos/<hostname>/default.nix`
- Docker services managed via Ansible with ironicbadger.docker-compose-generator role
- Environment files use `.env.example` pattern with force=no copying

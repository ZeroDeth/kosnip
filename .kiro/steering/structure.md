# Project Structure

## Root Level Organization

```
kosnip/
├── flake.nix              # Main Nix flake configuration
├── flake.lock             # Locked dependency versions
├── justfile               # Task runner commands
├── .gitmodules            # Git submodule definitions
├── ansible/               # Ansible playbooks and roles
├── docs/                  # Project documentation
├── hosts/                 # NixOS host configurations
└── lib/                   # Nix helper functions
```

## Core Directories

### `/hosts/`

- **`common/`**: Shared NixOS configuration modules

  - `nixos.nix`: Base system configuration (timezone, Docker, Nix settings)
  - `hardware-configuration.nix`: Common hardware settings
  - `packages.nix`: Shared package definitions
  - `disko.nix`: Disk partitioning configuration

- **`nixos/<hostname>/`**: Host-specific configurations
  - `default.nix`: Main host configuration file
  - `install-nix.sh`: Automated installation script

### `/lib/`

- `default.nix`: Library exports
- `helpers.nix`: Contains `mkNixos` function for standardized host creation

### `/ansible/`

- `playbook.yaml`: Main Ansible playbook for service deployment
- `hosts.ini`: Inventory file for target hosts
- `roles/`: External Ansible roles (via git submodules)
  - `ansible-role-komodo/`: Komodo deployment role
  - `ironicbadger.docker-compose-generator/`: Docker Compose generation
- `services/`: Docker Compose service definitions per host
  - `nix-llm/`: LLM service configurations
  - `nix-metrics/`: Monitoring stack configs
  - `nix-npm/`: NPM registry configs
  - `nix-komodo/`: Komodo platform configs
  - `dockge/`: Docker management interface

### `/docs/`

- Technical documentation and planning documents
- Host-specific setup guides
- Architecture and consolidation plans

## Configuration Flow

1. **Flake Definition**: `flake.nix` defines all NixOS configurations
2. **Helper Function**: `lib/helpers.nix` provides `mkNixos` for consistent host creation
3. **Common Base**: All hosts inherit from `hosts/common/nixos.nix`
4. **Host Specifics**: Individual host configs in `hosts/nixos/<hostname>/default.nix`
5. **Service Deployment**: Ansible manages Docker services from `ansible/services/`

## Naming Conventions

- Host configurations: `nix-<service>` (e.g., `nix-llm`, `nix-metrics`)
- Service directories: Match hostname for consistency
- Environment files: `.env.example` pattern with runtime `.env` generation
- Install scripts: `install-nix.sh` in each host directory

# Taskfile Automation Documentation

## Overview

This project uses [Task](https://taskfile.dev/) for automation and deployment management across multiple NixOS hosts. The Taskfile system provides a scalable and organized approach to managing infrastructure deployments, replacing the previous justfile implementation.

## Prerequisites

- [Task](https://taskfile.dev/) installed
- [Ansible](https://www.ansible.com/) for configuration management
- SSH access to target NixOS hosts
- Git for repository management

## Installation

Install Task using your preferred method:

```bash
# macOS with Homebrew
brew install go-task/tap/go-task

# Or with Flox (as used in this project)
flox install go-task
```

## Project Structure

```
kosnip/
├── Taskfile.yml              # Main task configuration
├── tasks/
│   ├── install.yml           # Installation-specific tasks
│   └── deploy.yml            # Deployment-specific tasks
├── ansible/
│   ├── playbook.yaml         # Ansible deployment playbook
│   └── hosts.ini             # Inventory of NixOS hosts
├── hosts/nixos/              # NixOS host configurations
│   ├── nix-llm/
│   ├── nix-metrics/
│   ├── nix-komodo-01/
│   ├── nix-komodo-02/
│   └── nix-npm/
└── docs/
    └── taskfile-automation.md # This documentation
```

## Available Tasks

### Core Tasks

| Task | Description | Usage |
|------|-------------|-------|
| `task --list` | Show all available tasks | `task --list` |
| `task list-hosts` | List all available NixOS hosts | `task list-hosts` |
| `task dev` | Show development shortcuts | `task dev` |

### Installation Tasks

| Task | Description | Usage |
|------|-------------|-------|
| `task install` | Install NixOS on a remote host | `task install HOST=nix-llm IP=192.168.1.100` |
| `task install:nix-llm` | Install NixOS on nix-llm host | `task install:nix-llm IP=192.168.1.100` |
| `task install:nix-metrics` | Install NixOS on nix-metrics host | `task install:nix-metrics IP=192.168.1.101` |
| `task install:nix-komodo-01` | Install NixOS on nix-komodo-01 host | `task install:nix-komodo-01 IP=192.168.1.102` |
| `task install:nix-komodo-02` | Install NixOS on nix-komodo-02 host | `task install:nix-komodo-02 IP=192.168.1.103` |
| `task install:nix-npm` | Install NixOS on nix-npm host | `task install:nix-npm IP=192.168.1.104` |
| `task install-all` | Install NixOS on all hosts | `task install-all` (requires IP mapping) |

### Deployment Tasks

| Task | Description | Usage |
|------|-------------|-------|
| `task deploy:nix-llm` | Deploy LLM services (Open WebUI, Ollama) | `task deploy:nix-llm` |
| `task deploy:nix-metrics` | Deploy monitoring (Prometheus, Grafana) | `task deploy:nix-metrics` |
| `task deploy:nix-komodo-01` | Deploy Komodo services to host 01 | `task deploy:nix-komodo-01` |
| `task deploy:nix-komodo-02` | Deploy Komodo services to host 02 | `task deploy:nix-komodo-02` |
| `task deploy:nix-npm` | Deploy Nginx Proxy Manager | `task deploy:nix-npm` |
| `task deploy:komodo` | Deploy to both Komodo hosts | `task deploy:komodo` |
| `task deploy:all` | Deploy to all hosts | `task deploy:all` |

### Configuration Management

| Task | Description | Usage |
|------|-------------|-------|
| `task compose` | Deploy Docker Compose services | `task compose HOST=nix-npm` |
| `task config` | Deploy configuration files only | `task config HOST=nix-npm` |
| `task dockge` | Deploy Dockge container management | `task dockge HOST=nix-npm` |
| `task update` | Update NixOS configuration | `task update HOST=nix-llm` |
| `task update-all` | Update all NixOS hosts | `task update-all` |

### Utility Tasks

| Task | Description | Usage |
|------|-------------|-------|
| `task fmt` | Format Nix files | `task fmt` |
| `task check` | Check Nix flake configuration | `task check` |
| `task validate` | Format and validate Nix files | `task validate` |
| `task lint` | Format Nix files (alias for fmt) | `task lint` |
| `task show-settings` | Show system settings and status | `task show-settings HOST=nix-llm` |
| `task sub-update` | Update git submodules | `task sub-update` |
| `task clean` | Clean up temporary files | `task clean` |

## Host Configuration

### Current Hosts

The system automatically discovers hosts from the `hosts/nixos/` directory:

- **nix-llm**: LLM services (Open WebUI, Ollama)
- **nix-metrics**: Monitoring stack (Prometheus, Grafana)
- **nix-komodo-01**: Komodo deployment server 01
- **nix-komodo-02**: Komodo deployment server 02
- **nix-npm**: Nginx Proxy Manager

### Adding New Hosts

1. Create a new directory in `hosts/nixos/` with your host name
2. Add the host configuration files
3. Update `ansible/hosts.ini` with the new host entry
4. The Taskfile will automatically discover and include the new host

## Usage Examples

### Installing a New Host

```bash
# Install NixOS on a new host
task install:nix-llm IP=192.168.1.100

# Or use the generic install task
task install HOST=nix-llm IP=192.168.1.100
```

### Deploying Services

```bash
# Deploy services to a specific host (includes Dockge automatically)
task deploy:nix-npm

# Deploy with verbose output
task deploy:nix-npm VERBOSE=true

# Deploy to all Komodo hosts
task deploy:komodo

# Deploy to all hosts
task deploy:all
```

### Configuration Updates

```bash
# Update NixOS configuration on a host
task update HOST=nix-llm

# Update all hosts
task update-all

# Deploy only configuration files
task config HOST=nix-npm
```

### Development and Debugging

```bash
# Show all available hosts
task list-hosts

# Show development shortcuts
task dev

# Show system status for a host
task show-settings HOST=nix-llm

# Dry run a deployment
task deploy:nix-npm -n
```

## Advanced Usage

### Verbose Output

Add `VERBOSE=true` to any deployment task for detailed Ansible output:

```bash
task deploy:nix-npm VERBOSE=true
task compose HOST=nix-metrics VERBOSE=true
```

### Batch Operations

```bash
# Deploy to specific host groups
task deploy:komodo          # Both Komodo hosts
task deploy:all             # All hosts

# Update all configurations
task update-all
```

### Custom Variables

Tasks support custom variables that can be passed at runtime:

```bash
# Installation with IP
task install HOST=new-host IP=192.168.1.200

# Deployment with verbose output
task compose HOST=nix-llm VERBOSE=true
```

## Integration with Ansible

The Taskfile integrates seamlessly with the existing Ansible infrastructure:

- **Automatic Dockge Deployment**: Every `compose` command includes Dockge deployment
- **Tag-based Execution**: Uses Ansible tags for selective task execution
- **Host Limiting**: Automatically limits Ansible execution to specified hosts
- **Configuration Management**: Handles both service deployment and configuration updates

## Migration from Shell Scripts

### Install Script Consolidation

Previously, each host had its own `install-nix.sh` script with nearly identical content. These have been **consolidated into the Taskfile** for better maintainability:

**Before (per-host scripts):**
```bash
# Each host had: hosts/nixos/nix-llm/install-nix.sh
cd hosts/nixos/nix-llm/
sh install-nix.sh
```

**After (unified Taskfile):**
```bash
# Single command for any host
task install HOST=nix-llm IP=192.168.1.100
```

### Benefits of Integration

- **Single source of truth**: All installation logic in one place
- **Better error handling**: Improved logging and status messages  
- **Automatic updates**: Repository is updated before installation
- **Consistent process**: Same steps for all hosts
- **Cleaner codebase**: No duplicate shell scripts

### Cleanup Old Scripts

If you want to remove the old install scripts:

```bash
task clean-install-scripts
```

This will delete all `install-nix.sh` files since they're now redundant.

## Migration from Justfile

The Taskfile system maintains compatibility with all previous justfile functionality while adding:

- Better organization with include files
- Host-specific shortcuts
- Improved error handling
- Enhanced documentation
- Scalable architecture for 10+ hosts

### Command Mapping

| Old Justfile Command | New Taskfile Command |
|---------------------|---------------------|
| `just install nix-llm 192.168.1.100` | `task install:nix-llm IP=192.168.1.100` |
| `just compose nix-npm` | `task deploy:nix-npm` |
| `just update nix-llm` | `task update HOST=nix-llm` |

## Contributing

When adding new tasks or hosts:

1. Follow the existing naming conventions
2. Add appropriate documentation and descriptions
3. Include preconditions for required variables
4. Test with dry-run before committing
5. Update this documentation as needed

## References

- [Task Documentation](https://taskfile.dev/)
- [Ansible Documentation](https://docs.ansible.com/)
- [NixOS Manual](https://nixos.org/manual/nixos/stable/)

## Troubleshooting

### Common Issues

1. **Task not found**: Ensure Task is installed and in your PATH
2. **Host not found**: Check that the host directory exists in `hosts/nixos/`
3. **SSH connection issues**: Verify SSH access to target hosts
4. **Ansible errors**: Use `VERBOSE=true` for detailed error output

### Debugging Commands

```bash
# Check Task installation
task --version

# List all available tasks
task --list

# Show task summary
task --summary deploy:nix-npm

# Dry run to see what would be executed
task deploy:nix-npm -n

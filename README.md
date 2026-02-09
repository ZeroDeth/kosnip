# Kosnip - NixOS Infrastructure Management

A comprehensive infrastructure management system for deploying and managing multiple NixOS hosts with Docker Compose services.

## 🚀 Quick Start

```bash
# List all available tasks
task --list

# List all available hosts
task list-hosts

# Deploy services to a host
task deploy:nix-npm

# Install NixOS on a new host
task install:nix-llm IP=192.168.1.100
```

## 📋 Overview

This project manages a fleet of NixOS hosts running various services:

- **nix-llm**: LLM services (Open WebUI, Ollama)
- **nix-metrics**: Monitoring stack (Prometheus, Grafana)
- **nix-komodo-01/02**: Komodo deployment servers
- **nix-npm**: Nginx Proxy Manager

## 🛠 Technology Stack

- **[NixOS](https://nixos.org/)**: Declarative Linux distribution
- **[Task](https://taskfile.dev/)**: Task runner and automation
- **[Ansible](https://www.ansible.com/)**: Configuration management
- **[Docker Compose](https://docs.docker.com/compose/)**: Container orchestration
- **[Dockge](https://github.com/louislam/dockge)**: Docker Compose management UI

## 📁 Project Structure

```
kosnip/
├── Taskfile.yml              # Main automation configuration
├── tasks/                    # Organized task definitions
│   ├── install.yml           # Installation tasks
│   └── deploy.yml            # Deployment tasks
├── hosts/nixos/              # NixOS host configurations
│   ├── nix-llm/
│   ├── nix-metrics/
│   ├── nix-komodo-01/
│   ├── nix-komodo-02/
│   └── nix-npm/
├── ansible/                  # Ansible playbooks and roles
│   ├── playbook.yaml
│   ├── hosts.ini
│   └── services/
└── docs/                     # Documentation
    └── taskfile-automation.md
```

## 🎯 Key Features

### Automated Deployment
- **One-command deployment**: Deploy entire service stacks with single commands
- **Automatic Dockge integration**: Container management UI deployed with every service
- **Host-specific shortcuts**: Individual tasks for each host type
- **Batch operations**: Deploy to multiple hosts or all hosts at once

### Infrastructure Management
- **Dynamic host discovery**: Automatically finds all configured hosts
- **NixOS installation**: Remote installation on new hosts
- **Configuration updates**: Update and rebuild NixOS configurations
- **Service management**: Start, stop, and manage Docker Compose services

### Developer Experience
- **Organized task structure**: Clean separation of concerns
- **Comprehensive documentation**: Detailed usage examples and references
- **Error handling**: Proper preconditions and error messages
- **Development helpers**: Quick reference commands and utilities

## 📖 Documentation

- **[Taskfile Automation Guide](docs/taskfile-automation.md)** - Complete automation documentation
- **[Installation Guide](#installation)** - Setup and prerequisites
- **[Usage Examples](#usage-examples)** - Common workflows and commands
- **[Host Configuration](#host-configuration)** - Adding and managing hosts

## 🔧 Installation

### Prerequisites

1. **Task**: Task runner for automation
   ```bash
   # macOS with Homebrew
   brew install go-task/tap/go-task
   
   # Or with Flox
   flox install go-task
   ```

2. **Ansible**: Configuration management
   ```bash
   # macOS with Homebrew
   brew install ansible
   
   # Or with pip
   pip install ansible
   ```

3. **SSH Access**: Ensure SSH key-based authentication to target hosts

### Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/ZeroDeth/kosnip.git
   cd kosnip
   ```

2. Update git submodules:
   ```bash
   task sub-update
   ```

3. Verify installation:
   ```bash
   task --list
   task list-hosts
   ```

## 🎮 Usage Examples

### Host Installation

```bash
# Install NixOS on individual hosts
task install:nix-llm IP=192.168.1.100
task install:nix-metrics IP=192.168.1.101
task install:nix-komodo-01 IP=192.168.1.102
```

### Service Deployment

```bash
# Deploy to specific hosts
task deploy:nix-npm           # Nginx Proxy Manager
task deploy:nix-llm           # LLM services
task deploy:nix-metrics       # Monitoring stack

# Deploy to host groups
task deploy:komodo            # Both Komodo hosts
task deploy:all               # All hosts
```

### Configuration Management

```bash
# Update NixOS configurations
task update HOST=nix-llm
task update-all

# Deploy only configuration files
task config HOST=nix-npm

# Deploy only Dockge
task dockge HOST=nix-npm
```

### Development and Debugging

```bash
# Show development shortcuts
task dev

# Show system status
task show-settings HOST=nix-llm

# Verbose deployment
task deploy:nix-npm VERBOSE=true

# Dry run
task deploy:nix-npm -n
```

## 🏗 Host Configuration

### Current Hosts

| Host | Purpose | Services |
|------|---------|----------|
| nix-llm | AI/ML Services | Open WebUI, Ollama |
| nix-metrics | Monitoring | Prometheus, Grafana |
| nix-komodo-01 | Deployment Server | Komodo Core, MongoDB |
| nix-komodo-02 | Deployment Server | Komodo Periphery |
| nix-npm | Reverse Proxy | Nginx Proxy Manager |

### Adding New Hosts

1. Create host directory:
   ```bash
   mkdir -p hosts/nixos/new-host
   ```

2. Add NixOS configuration files

3. Update Ansible inventory:
   ```bash
   echo "new-host ansible_ssh_user=root" >> ansible/hosts.ini
   ```

4. The Taskfile will automatically discover the new host

## 🔄 Migration from Justfile

This project has migrated from justfile to Taskfile for better organization and scalability. All previous functionality is maintained with improved structure:

| Old Command | New Command |
|-------------|-------------|
| `just install nix-llm 192.168.1.100` | `task install:nix-llm IP=192.168.1.100` |
| `just compose nix-npm` | `task deploy:nix-npm` |
| `just update nix-llm` | `task update HOST=nix-llm` |

## 🤝 Contributing

1. Follow existing naming conventions
2. Add appropriate documentation
3. Include preconditions for required variables
4. Test with dry-run before committing
5. Update documentation as needed

## 📚 References

- [Task Documentation](https://taskfile.dev/)
- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Ansible Documentation](https://docs.ansible.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

**Note**: This infrastructure is designed for homelab and development environments. Ensure proper security measures for production deployments.

# Quick Reference Card

## 🚀 Essential Commands

```bash
# Show all tasks
task --list

# Show development shortcuts
task dev

# List all hosts
task list-hosts
```

## 🏗 Installation

```bash
# Install NixOS on specific hosts
task install:nix-llm IP=192.168.1.100
task install:nix-metrics IP=192.168.1.101
task install:nix-komodo-01 IP=192.168.1.102
task install:nix-komodo-02 IP=192.168.1.103
task install:nix-npm IP=192.168.1.104
```

## 🚢 Deployment

```bash
# Deploy to individual hosts
task deploy:nix-llm           # LLM services
task deploy:nix-metrics       # Monitoring
task deploy:nix-komodo-01     # Komodo host 1
task deploy:nix-komodo-02     # Komodo host 2
task deploy:nix-npm           # Nginx Proxy Manager

# Deploy to groups
task deploy:komodo            # Both Komodo hosts
task deploy:all               # All hosts
```

## ⚙️ Configuration

```bash
# Update NixOS configurations
task update HOST=nix-llm
task update-all

# Deploy only configs
task config HOST=nix-npm

# Deploy only Dockge
task dockge HOST=nix-npm
```

## 🔧 Utilities

```bash
# Show system status
task show-settings HOST=nix-llm

# Clean temporary files
task clean

# Format Nix files
task lint

# Update submodules
task sub-update
```

## 📚 Documentation

```bash
# Open main docs
task docs

# Open automation guide
task docs-automation
```

## 🐛 Debugging

```bash
# Verbose output
task deploy:nix-npm VERBOSE=true

# Dry run
task deploy:nix-npm -n

# Show task summary
task --summary deploy:nix-npm
```

## 📋 Host Overview

| Host | Purpose | Services |
|------|---------|----------|
| nix-llm | AI/ML | Open WebUI, Ollama |
| nix-metrics | Monitoring | Prometheus, Grafana |
| nix-komodo-01 | Deployment | Komodo Core, MongoDB |
| nix-komodo-02 | Deployment | Komodo Periphery |
| nix-npm | Proxy | Nginx Proxy Manager |

## 🔗 Quick Links

- [Main README](../README.md)
- [Full Automation Guide](taskfile-automation.md)
- [Task Documentation](https://taskfile.dev/)
- [NixOS Manual](https://nixos.org/manual/nixos/stable/)

# Documentation Index

Welcome to the Kosnip documentation! This directory contains comprehensive guides and references for managing your NixOS infrastructure.

## 📚 Available Documentation

### Core Documentation
- **[Taskfile Automation Guide](taskfile-automation.md)** - Complete automation system documentation
  - Task reference and usage examples
  - Installation and deployment workflows
  - Advanced configuration options
  - Troubleshooting and debugging
- **[Quick Reference Card](quick-reference.md)** - Essential commands and shortcuts

### Quick References

#### Essential Commands
```bash
# Show all tasks
task --list

# Show development shortcuts
task dev

# List all hosts
task list-hosts
```

#### Common Workflows
```bash
# Install new host (requires both HOST and IP during initial setup)
task install HOST=nix-llm IP=192.168.1.100

# Deploy services to existing hosts
task deploy:nix-llm
task deploy:nix-metrics

# Update configuration
task update HOST=nix-llm
```

## 🎯 Getting Started

1. **New to the project?** Start with the main [README](../README.md)
2. **Setting up automation?** Check the [Taskfile Automation Guide](taskfile-automation.md)
3. **Need quick reference?** Use `task dev` for common commands

## 🏗 Architecture Overview

```
Infrastructure Management
├── Task Automation (Taskfile.yml)
├── Configuration Management (Ansible)
├── Container Orchestration (Docker Compose)
├── Service Management (Dockge)
└── Host Management (NixOS)
```

## 🔧 Host Types

| Host Type | Purpose | Documentation |
|-----------|---------|---------------|
| nix-llm | AI/ML Services | [Taskfile Guide](taskfile-automation.md#deployment-tasks) |
| nix-metrics | Monitoring Stack | [Taskfile Guide](taskfile-automation.md#deployment-tasks) |
| nix-komodo-* | Deployment Servers | [Taskfile Guide](taskfile-automation.md#deployment-tasks) |
| nix-npm | Reverse Proxy | [Taskfile Guide](taskfile-automation.md#deployment-tasks) |

## 📖 Additional Resources

- [Task Official Documentation](https://taskfile.dev/)
- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Ansible Documentation](https://docs.ansible.com/)
- [Docker Compose Reference](https://docs.docker.com/compose/)

## 🤝 Contributing to Documentation

When updating documentation:

1. Keep examples practical and tested
2. Include both basic and advanced usage
3. Update the index when adding new docs
4. Follow the existing markdown style
5. Test all command examples

## 📝 Documentation Standards

- Use clear, descriptive headings
- Include practical examples
- Provide troubleshooting sections
- Reference related documentation
- Keep content up-to-date with code changes

---

For questions or improvements, please contribute to the project repository.

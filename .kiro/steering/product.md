# Product Overview

**Kosnip** is a NixOS-based infrastructure management system that provides declarative configuration for multiple specialized hosts in a homelab/enterprise environment.

## Core Purpose

- Manages multiple NixOS hosts with different roles (LLM services, metrics monitoring, npm registry, Komodo deployment platform)
- Provides automated deployment and configuration management through Nix flakes
- Integrates Docker containerization with NixOS declarative configuration
- Supports remote installation and deployment via SSH

## Key Services

- **nix-llm**: AI/LLM hosting platform with OpenWebUI
- **nix-metrics**: Monitoring stack (Prometheus, Grafana)
- **nix-npm**: NPM registry and proxy management
- **nix-komodo**: Deployment and orchestration platform (dual hosts for HA)
- **dockge**: Docker compose management interface

## Infrastructure Philosophy

The project follows Infrastructure as Code principles using NixOS's declarative configuration model, ensuring reproducible and version-controlled infrastructure deployments.

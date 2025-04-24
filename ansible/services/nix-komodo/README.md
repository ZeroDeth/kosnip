# Komodo Deployment Setup

This directory contains the configuration for deploying Komodo on NixOS systems using Docker Compose.

## Docker Compose Deployment

Similar to the nix-llm setup, the Komodo deployment uses Docker Compose via the `ironicbadger.docker-compose-generator` Ansible role. This approach is more compatible with NixOS than using systemd services directly, as NixOS manages services through its declarative configuration system.

The Docker Compose configuration includes:

- **MongoDB**: Database for Komodo Core
- **Komodo Core**: The main Komodo server
- **Komodo Periphery**: The agent that connects to Komodo Core

### Configuration

The Docker Compose configuration in `komodo.yaml` includes these settings:

- MongoDB for persistent data storage
- Komodo Core exposed on port 9120
- Komodo Periphery configured to connect to Komodo Core
- Environment variables stored in `.env` file
- Persistent storage in /opt/appdata/komodo/

For production use, encrypt the sensitive variables in the `.env` file with ansible-vault:
```bash
ansible-vault encrypt_string 'yoursecretpasskey' --name 'KOMODO_PASSKEY'
ansible-vault encrypt_string 'yourdbpassword' --name 'DB_PASSWORD'
```

### Usage

To deploy using Ansible:

```bash
# Run the playbook
ansible-playbook -i ansible/hosts.ini ansible/playbook.yaml --tags compose
```

## NixOS Integration

The NixOS configuration for the Komodo hosts is located at:
- `hosts/nixos/nix-komodo-01/default.nix`
- (You'll need to create a similar configuration for nix-komodo-02)

Make sure Docker is enabled in the NixOS configuration:

```nix
virtualisation.docker = {
  enable = true;
};
```

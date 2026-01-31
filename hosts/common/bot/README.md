# Bot Preset

Standardized configuration for all bots. **No exceptions.**

## Usage

```nix
{ pkgs, ... }:

{
  imports = [
    ./../common/bot/bot-preset.nix
  ];

  bot = {
    enable = true;
    name = "black";
    owner = "clawzero";
    project = "black-claw";
    environment = "dev_black";
    enablePlugins = [ "sag" ];
  };
}
```

## Naming Convention

| Component | Pattern | Example |
|-----------|---------|---------|
| Machine name | `{name}` | `black` |
| Hostname | `{name}` | `black` |
| User | `{name}` | `black` |
| SSH/GPG keys | `{name}-claw` | `black-claw` |
| Doppler workspace | `claw` | `claw` |
| Doppler project | `{name}-claw` | `black-claw` |
| Doppler env | `dev_{name}` | `dev_black` |

## Standard Paths (all bots)

| Path | Purpose |
|------|---------|
| `/var/lib/openclaw` | State directory |
| `/var/lib/openclaw/workspace` | Workspace |
| `/var/lib/openclaw/openclaw.json` | Config |
| `/tmp/openclaw/openclaw-gateway.log` | Logs |
| `/run/secrets/openclaw-env` | Doppler secrets |

## Doppler (all bots)

| Variable | Value | Example |
|----------|-------|---------|
| `DOPPLER_WORKSPACE` | `claw` | `claw` |
| `DOPPLER_PROJECT` | `{name}-claw` | `black-claw` |
| `DOPPLER_ENVIRONMENT` | `dev_{name}` | `dev_black` |
| `DOPPLER_CONFIG` | `dev_{name}` | `dev_black` |

## First-Party Plugins

| Plugin | Default |
|--------|---------|
| `sag` (TTS) | Enabled |

## SSH & GPG Keys

Keys stored in GitHub, pulled during initial setup:
- SSH key: `id_ed25519-{name}-claw`
- GPG key: `{name}-claw.asc`

Setup script pulls keys from:
```
https://github.com/clawzero/dotfiles/raw/main/keys/{name}-claw/*
```

## Included by Preset

- Tailscale mesh networking
- OpenClaw via nix-openclaw
- Systemd service
- Doppler integration
- User `{name}` (not zerodeth)
- Standard directories
- Base packages (tailscale, git, doppler)

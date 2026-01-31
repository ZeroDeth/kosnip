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
    owner = "zerodeth";
    project = "black";
    environment = "dev";
    enablePlugins = [ "sag" ];
  };
}
```

## Standard Paths (all bots)

| Path | Purpose |
|------|---------|
| `/var/lib/openclaw` | State directory |
| `/var/lib/openclaw/workspace` | Workspace |
| `/var/lib/openclaw/openclaw.json` | Config |
| `/tmp/openclaw/openclaw-gateway.log` | Logs |
| `/run/secrets/openclaw-env` | Doppler secrets |

## Doppler (all bots)

| Variable | Source |
|----------|--------|
| `DOPPLER_ENVIRONMENT` | bot.environment |
| `DOPPLER_PROJECT` | bot.project |
| `DOPPLER_CONFIG` | bot.environment |

## First-Party Plugins

| Plugin | Default |
|--------|---------|
| `sag` (TTS) | Enabled |

## Included by Preset

- Tailscale mesh networking
- OpenClaw via nix-openclaw
- Systemd service
- User configuration
- Standard directories
- Base packages (tailscale, git, doppler)

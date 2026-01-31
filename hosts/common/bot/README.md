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
    imageBackend = "openai";  # openai, gemini, or brave
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

## AI Providers (standardized)

| Role | Provider | Model |
|------|----------|-------|
| **Default** | MiniMax | `MiniMax-M2.1` |
| **Failback** | Anthropic | `claude-opus-4-5` |

## Image Analysis (configurable)

| Option | Provider | Model |
|--------|----------|-------|
| `openai` | OpenAI | `gpt-4o` |
| `gemini` | Google | `gemini-1.5-pro` |
| `brave` | Brave | `brave-search` |

Set via `bot.imageBackend`.

## Web Search

| Provider | API Key |
|----------|---------|
| Brave | `$BRAVE_API_KEY` |

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

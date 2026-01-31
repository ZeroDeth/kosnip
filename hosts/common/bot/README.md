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

## Email (configurable per bot)

Each bot can have different email setup:

| Bot | Email | SMTP |
|-----|-------|------|
| Yellow | `clawzero.agent+yellow@gmail.com` | smtp.gmail.com |
| Pink | `yesim+pink@abdalla.co.uk` | Custom |

### Configuration

```nix
bot = {
  enable = true;
  name = "yellow";
  emailAddress = "clawzero.agent+yellow@gmail.com";
  emailSmtpHost = "smtp.gmail.com";
  emailSmtpUser = "clawzero.agent@gmail.com";
  emailPasswordSecret = "GMAIL_APP_PASSWORD";
};
```

```nix
bot = {
  enable = true;
  name = "pink";
  emailAddress = "yesim+pink@abdalla.co.uk";
  emailSmtpHost = "smtp.custom.provider.com";
  emailSmtpUser = "yesim+pink@abdalla.co.uk";
  emailPasswordSecret = "PINK_EMAIL_PASSWORD";
};
```

### Guardrails

**Restricted recipients:**
- `sherif@abdalla.co.uk` (Sherif)
- `pink@abdalla.co.uk` (Yesim)
- No emails to unknown recipients

**Consent required:**
- New recipients require explicit consent from Sherif
- All emails logged

```nix
programs.openclaw.config = {
  email = {
    address = "clawzero.agent+${botCfg.name}@gmail.com";
    smtp.host = "smtp.gmail.com";
    smtp.user = "clawzero.agent@gmail.com";
    smtp.password = "$GMAIL_APP_PASSWORD";
    
    # Guardrails
    allowedRecipients = [
      "sherif@abdalla.co.uk"
      "pink@abdalla.co.uk"
    ];
    requireConsent = true;
    logAll = true;
  };
};
```

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

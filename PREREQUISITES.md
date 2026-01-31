# Bot Prerequisites

**Must be completed BEFORE creating a new bot.** No exceptions.

---

## Doppler

| Secret | Required | Example |
|--------|----------|---------|
| `DOPPLER_TOKEN` | Yes | Service token for Doppler CLI |
| `TELEGRAM_BOT_TOKEN` | Yes (if Telegram channel) | Telegram bot token |
| `ANTHROPIC_API_KEY` | Yes | Claude API key |
| `OPENAI_API_KEY` | Optional | GPT-4 API key |

**Doppler project must exist:**
- Named matching the bot (e.g., `black`, `green`, `pink`)
- Environment: `dev` (default)
- Service token with `secrets.read` scope

---

## GitHub

| Item | Required | Notes |
|------|----------|-------|
| Repository | Yes | Where bot config lives |
| Branch protection | No | Optional for production bots |
| GitHub Actions secrets | Optional | For CI/CD deployment |

---

## Tailscale

| Item | Required | Notes |
|------|----------|-------|
| Tailscale account | Yes | Access to tailnet |
| Auth key or OAuth | Yes | For auto-joining machines |
| Machine hostname | Yes | e.g., `black.ts.net` |

---

## Repository Structure

```
bots/
├── hosts/
│   └── nix-{bot-name}/
│       ├── default.nix    # Bot configuration
│       ├── install-nix.sh # Installation script
│       └── README.md      # Bot documentation
└── common/
    └── bot/
        ├── bot-preset.nix # Standardized configuration
        └── README.md      # Preset documentation
```

---

## Naming Convention

| Pattern | Example |
|---------|---------|
| Bot name | `black`, `green`, `pink` |
| NixOS hostname | `black`, `green`, `pink` |
| Doppler project | `black`, `green`, `pink` |
| Tailscale hostname | `black.ts.net` |

---

## Quick Checklist

Before creating a new bot, verify:

- [ ] Doppler project exists
- [ ] Doppler service token created
- [ ] Tailscale auth key ready
- [ ] Telegram bot token in Doppler (if needed)
- [ ] API keys in Doppler (Claude, OpenAI, etc.)
- [ ] Repository branch exists
- [ ] Unique bot name (not used before)

---

## Example: Adding a New Bot

```bash
# 1. Verify prerequisites
cat PREREQUISITES.md

# 2. Create Doppler project
doppler projects create "pink" --config dev

# 3. Add secrets
doppler secrets set TELEGRAM_BOT_TOKEN="..." --project pink --config dev

# 4. Create Tailscale auth key
#    (via Tailscale admin console)

# 5. Create bot config using bot-preset.nix
#    (see hosts/common/bot/bot-preset.nix)
```

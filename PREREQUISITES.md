# Bot Prerequisites

**Must be completed BEFORE creating a new bot.** No exceptions.

---

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

---

## GitHub

| Item | Required | Value |
|------|----------|-------|
| GitHub user | Yes | `clawzero` |
| SSH public keys | Yes | `id_ed25519-{name}-claw.pub` in claw-dot repo |
| SSH private keys | Yes | In Doppler (secret storage) |
| GPG public keys | Yes | `{name}-claw.asc` in claw-dot repo |
| GPG private keys | Yes | In Doppler (secret storage) |
| Repository | Yes | `clawzero/claw-nix` |

**Keys storage:**
```
Public keys  ──► claw-dot repo (anyone can read)
Private keys ──► Doppler (secret storage)
```

---

## Doppler

| Variable | Value | Example |
|----------|-------|---------|
| `DOPPLER_WORKSPACE` | `claw` | `claw` |
| `DOPPLER_PROJECT` | `{name}-claw` | `black-claw` |
| `DOPPLER_ENVIRONMENT` | `dev_{name}` | `dev_black` |
| `DOPPLER_CONFIG` | `dev_{name}` | `dev_black` |

**Required secrets in Doppler:**
- `TELEGRAM_BOT_TOKEN` (if Telegram channel)
- `ANTHROPIC_API_KEY`
- `OPENAI_API_KEY` (optional)

**Setup:**
```bash
# Create Doppler project
doppler projects create "black-claw" --workspace claw

# Set secrets
doppler secrets set TELEGRAM_BOT_TOKEN="..." --project black-claw --config dev_black
doppler secrets set ANTHROPIC_API_KEY="..." --project black-claw --config dev_black
```

---

## Tailscale

| Item | Required | Value |
|------|----------|-------|
| Auth key | Yes | From Tailscale admin console |
| Hostname | Yes | `{name}` | `black` |
| Tailnet | Yes | Your tailnet |

---

## Quick Checklist

Before creating a new bot, verify:

- [ ] GitHub user: `clawzero`
- [ ] SSH key: `id_ed25519-{name}-claw` in dotfiles repo
- [ ] GPG key: `{name}-claw.asc` in dotfiles repo
- [ ] Doppler project: `{name}-cl claw`
- [ ] Doppler environment: `dev_{name}`
- [ ] Doppler secrets set
- [ ] Tailscale auth key ready
- [ ] Hostname: `{name}`

---

## Example: Adding Pink Bot

```bash
# 1. Add keys to dotfiles repo
#    https://github.com/clawzero/dotfiles/tree/main/keys/pink-claw/

# 2. Create Doppler project
doppler projects create "pink-claw" --workspace claw

# 3. Add secrets
doppler secrets set TELEGRAM_BOT_TOKEN="..." --project pink-claw --config dev_pink
doppler secrets set ANTHROPIC_API_KEY="..." --project pink-claw --config dev_pink

# 4. Create Tailscale auth key for "pink"

# 5. Create bot config:
#    hosts/nixos/nix-pink/default.nix
```

---

## Repository Structure

```
claw-nix/
├── PREREQUISITES.md          # This file
├── hosts/
│   ├── common/
│   │   └── bot/
│   │       ├── bot-preset.nix    # Standardized config
│   │       └── README.md         # Preset docs
│   └── nixos/
│       └── nix-{name}/
│           ├── default.nix       # Bot config (uses preset)
│           ├── install-nix.sh    # Installation script
│           └── README.md         # Bot docs
```

# nix-claw-black

Sherif's personal AI bot (OpenClaw).

## Standards

Following patterns from:
- [nix-openclaw](https://github.com/openclaw/nix-openclaw) (official)
- [ai-stack](https://github.com/clawzero/ai-stack) (fleet patterns)

## Paths (standardized)

| Path | Purpose |
|------|---------|
| `/var/lib/openclaw` | State directory |
| `/var/lib/openclaw/workspace` | Workspace |
| `/var/lib/openclaw/openclaw.json` | Config |
| `/tmp/openclaw/openclaw-gateway.log` | Logs |

## Integration

- **OpenClaw**: Nix package via nix-openclaw (NOT Docker)
- **Tailscale**: Mesh networking, hostname: `black`
- **Doppler**: Secrets via environment variables
- **Systemd**: Auto-start on boot

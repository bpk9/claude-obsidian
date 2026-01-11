# Obsidian + Claude Code Hybrid Container

![Docker Pulls](https://img.shields.io/docker/pulls/bpk9/obsidian-claude)
![Docker Image Size](https://img.shields.io/docker/image-size/bpk9/obsidian-claude)
![GitHub Stars](https://img.shields.io/github/stars/bpk9/claude-obsidian?style=social)
![License](https://img.shields.io/github/license/bpk9/claude-obsidian)

A "fat container" combining [Obsidian](https://obsidian.md/) (GUI knowledge base) with [Claude Code](https://claude.ai/code) (CLI AI agent) and SSH access, designed for Unraid deployment.

## Features

- **Obsidian GUI** - Full graphical Obsidian interface accessible via web browser
- **Claude Code CLI** - Anthropic's AI coding assistant with full file system access to your vault
- **Persistent SSH** - SSH into the container from any device (mobile-friendly)
- **s6-overlay Supervision** - Robust process management with automatic restarts
- **Persistent State** - SSH keys, Claude tokens, and vault data survive container updates

## Quick Start

### Docker Run

```bash
docker run -d \
  --name obsidian-claude \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=America/New_York \
  -e PASSWORD=your_secure_password \
  -p 3000:3000 \
  -p 2222:2222 \
  -v /path/to/vault:/config \
  bpk9/obsidian-claude:latest
```

### Docker Compose

```yaml
version: "3"
services:
  obsidian-claude:
    image: bpk9/obsidian-claude:latest
    container_name: obsidian-claude
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=America/New_York
      - PASSWORD=your_secure_password
    volumes:
      - /path/to/vault:/config
    ports:
      - 3000:3000   # Web GUI
      - 2222:2222   # SSH
    restart: unless-stopped
```

## Access

### Obsidian Web GUI

Open your browser and navigate to:
```
http://localhost:3000
```

### SSH Access

Connect via SSH to use Claude Code:
```bash
ssh -p 2222 abc@localhost
```

Then run Claude Code:
```bash
claude
```

## Configuration

| Variable | Description | Default |
|----------|-------------|---------|
| `PUID` | User ID for file permissions | `1000` |
| `PGID` | Group ID for file permissions | `1000` |
| `TZ` | Timezone | `America/New_York` |
| `PASSWORD` | SSH password for user `abc` | Random (logged) |

| Port | Description |
|------|-------------|
| `3000` | KasmVNC Web Interface |
| `3001` | KasmVNC HTTPS Interface |
| `2222` | SSH Access |

| Volume | Description |
|--------|-------------|
| `/config` | Obsidian vault, SSH keys, Claude config |

## Claude Code Authentication

On first use, Claude Code requires authentication:

1. SSH into the container
2. Run `claude`
3. Follow the OAuth flow (a URL will be provided)
4. Complete authentication in your browser
5. Tokens are stored in `/config/claude-profile/` and persist across restarts

## Persistent Data

The container stores persistent data in `/config`:

```
/config/
├── ssh/              # SSH host keys (persist identity)
│   ├── ssh_host_ed25519_key
│   ├── ssh_host_rsa_key
│   └── user_keys/    # User authorized_keys
├── claude-profile/   # Claude Code tokens and config
└── [vault files]     # Your Obsidian vault
```

## Security Recommendations

1. **Use VPN**: Instead of port-forwarding SSH to the internet, use Unraid's WireGuard VPN
2. **Strong Password**: Set a strong `PASSWORD` environment variable
3. **SSH Keys**: For enhanced security, add your public key to `/config/ssh/user_keys/authorized_keys`
4. **Firewall**: Only allow local network or VPN subnet access to the container

## Building Locally

```bash
git clone https://github.com/bpk9/claude-obsidian.git
cd claude-obsidian
docker build -t obsidian-claude:local .
```

## Unraid Installation

1. Search for "Obsidian-Claude-Hybrid" in Community Applications
2. Configure ports and vault path
3. Set your SSH password
4. Click "Apply"

## License

MIT License - See [LICENSE](LICENSE) for details.

## Acknowledgments

- [LinuxServer.io](https://linuxserver.io/) for the excellent Obsidian base image
- [Anthropic](https://anthropic.com/) for Claude Code
- [Obsidian](https://obsidian.md/) for the knowledge base application

# Codespaces Configuration

This directory contains the GitHub Codespaces dev container configuration.

## Port Visibility Issue

If port 8080 shows as **private** after creating a Codespace, you need to manually change it to **public**:

### Manual Steps:
1. Open the **PORTS** panel at the bottom of VS Code (next to TERMINAL)
2. Find port **8080** in the list
3. **Right-click** on port 8080
4. Select **Port Visibility** → **Public**
5. Refresh your browser and access Jenkins

### Why is this needed?

The `devcontainer.json` includes `"visibility": "public"` for port 8080, but GitHub Codespaces may not always apply this setting automatically, especially:
- On the first Codespace creation
- If there's an organization policy
- If the port is forwarded before the container is fully started

The setup script attempts to set the port visibility automatically using the GitHub CLI, but if that fails, manual intervention is required.

## Files

- **devcontainer.json** - Dev container specification
- **setup.sh** - Initialization script (installs yq, configures URLs, creates welcome message)
- **welcome.txt** - Generated welcome message (not in git, created at runtime)
- **README.md** - This file

## Accessing Jenkins

After starting a tutorial with `docker compose --profile <name> up -d`:
- Jenkins URL: `https://<codespace>-8080.<domain>` (shown in PORTS panel)
- Default credentials: admin/admin

## Troubleshooting

**Port 8080 refuses connection:**
- Ensure port visibility is set to **public** (see steps above)
- Verify Jenkins is running: `docker compose ps`
- Check logs: `docker compose logs jenkins_controller`

**Welcome message not showing:**
- Run: `source ~/.bashrc` in your terminal
- Or open a new terminal window

**yq not found:**
- Run: `bash .devcontainer/setup.sh` manually

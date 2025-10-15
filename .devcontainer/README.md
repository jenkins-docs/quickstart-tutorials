# Codespaces Configuration

This directory contains the GitHub Codespaces dev container configuration.

## Port Visibility

Port 8080 may show as **private** in the PORTS panel, but this is usually not an issue - you can still access Jenkins using the forwarded URL.

**Note:** The port visibility label in the UI can be misleading. Even when marked as "private", the Jenkins URL provided in the welcome message will work in your browser. Only change visibility to "public" if you need to share the URL with others.

### Manual Steps (if needed for sharing):
1. Open the **PORTS** panel at the bottom of VS Code (next to TERMINAL)
2. Find port **8080** in the list
3. **Right-click** on port 8080
4. Select **Port Visibility** → **Public**

### Technical Details

The `devcontainer.json` includes `"visibility": "public"` for port 8080, but GitHub Codespaces may not always apply this setting automatically. The setup script attempts to set visibility using the GitHub CLI, but this is optional since Codespaces authentication allows private port access.

## Files

- **devcontainer.json** - Dev container specification
- **setup.sh** - Initialization script (installs yq, configures URLs, creates welcome message)
- **welcome.txt** - Generated welcome message (not in git, created at runtime)
- **README.md** - This file

## Accessing Jenkins

After starting a tutorial with `docker compose --profile <name> up -d`:
- Jenkins URL: `https://<codespace>-8080.<domain>` (shown in PORTS panel)
- Default credentials: admin/admin

**Important:** Open Jenkins in a regular browser tab, not the VS Code preview pane. The preview may show "Please reopen the preview" due to Jenkins security headers. Click the globe icon 🌐 in the PORTS panel or copy the URL to your browser.

## Troubleshooting

**Port 8080 refuses connection:**
- Verify Jenkins is running: `docker compose ps`
- Check logs: `docker compose logs jenkins_controller`
- Wait 1-2 minutes for Jenkins to fully start
- Port visibility (private/public) should not affect access for the Codespace owner

**Welcome message not showing:**
- Run: `source ~/.bashrc` in your terminal
- Or open a new terminal window

**yq not found:**
- Run: `bash .devcontainer/setup.sh` manually

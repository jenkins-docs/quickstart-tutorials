#!/usr/bin/env bash
# GitHub Codespaces setup script for Jenkins Quickstart Tutorials
# This script configures the Codespace environment and prepares Jenkins URL configuration

set -Eeuo pipefail  # Exit on error, undefined variables, pipe failures

echo "================================"
echo "Setting up Jenkins Tutorials Environment"
echo "================================"

# Install yq (YAML processor) - required for JCasc configuration
echo "📦 Installing yq YAML processor..."
YQ_VERSION="${YQ_VERSION:-v4.53.2}"
YQ_URL="https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64"

# Try wget first, fall back to curl if unavailable
if command -v wget &> /dev/null; then
    sudo wget -qO /usr/local/bin/yq "${YQ_URL}"
elif command -v curl &> /dev/null; then
    sudo curl -fsSL -o /usr/local/bin/yq "${YQ_URL}"
else
    echo "❌ Error: Neither wget nor curl found. Cannot download yq."
    exit 1
fi

sudo chmod a+x /usr/local/bin/yq
yq --version

# Verify Docker is available
echo "🐳 Verifying Docker installation..."
docker --version
docker compose version

# Create secrets directory if it doesn't exist
echo "📁 Creating secrets directory..."
mkdir -p ./secrets

# Run Codespaces URL configuration script
if [ -f "./dockerfiles/codespacesURL.sh" ]; then
    echo "🔧 Configuring Jenkins URLs for Codespaces..."
    chmod +x ./dockerfiles/codespacesURL.sh
    ./dockerfiles/codespacesURL.sh
else
    echo "⚠️  Warning: codespacesURL.sh not found, skipping URL configuration"
fi

# Create welcome message for future terminal sessions
WELCOME_FILE=".devcontainer/welcome.txt"
cat > "$WELCOME_FILE" << 'WELCOME_EOF'

================================
🚀 Jenkins Quickstart Tutorials
================================

Available tutorial profiles:
  • default  : Basic Jenkins with SSH agent
  • maven    : Jenkins + Maven build environment
  • python   : Jenkins + Python development
  • node     : Jenkins + Node.js/npm
  • multi    : Multibranch pipeline example
  • android  : Android development
  • golang   : Go development
  • cpp      : C++ development
  • dotnet   : .NET development
  • wizard   : Jenkins setup wizard (learning)

Quick Start:
  docker compose --profile <profile-name> up -d

Examples:
  docker compose --profile maven up -d
  docker compose --profile node up -d

To build locally:
  docker compose -f build-docker-compose.yaml --profile <profile-name> up -d

WELCOME_EOF

# Add Jenkins URL based on environment
if [ -n "${CODESPACE_NAME:-}" ] && [ -n "${GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN:-}" ]; then
    echo "Jenkins will be accessible at:" >> "${WELCOME_FILE}"
    echo "  https://${CODESPACE_NAME}-8080.${GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN}" >> "${WELCOME_FILE}"
else
    echo "Jenkins will be accessible at:" >> "${WELCOME_FILE}"
    echo "  http://localhost:8080" >> "${WELCOME_FILE}"
fi

echo "" >> "${WELCOME_FILE}"
echo "Default credentials: admin/admin" >> "${WELCOME_FILE}"
echo "================================" >> "${WELCOME_FILE}"
echo "" >> "${WELCOME_FILE}"

# Display the welcome message
cat "${WELCOME_FILE}"

echo "✅ Setup Complete! Welcome message saved to ${WELCOME_FILE}"
echo ""

# Add welcome message to .bashrc so it shows on every new terminal
# Use git rev-parse to find repo root dynamically instead of hardcoding path
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
WELCOME_PATH="${REPO_ROOT}/.devcontainer/welcome.txt"

if ! grep -q "Jenkins Quickstart Tutorials Welcome" ~/.bashrc; then
    echo "" >> ~/.bashrc
    echo "# Jenkins Quickstart Tutorials Welcome" >> ~/.bashrc
    echo "if [ -f \"${WELCOME_PATH}\" ]; then" >> ~/.bashrc
    echo "    cat \"${WELCOME_PATH}\"" >> ~/.bashrc
    echo "fi" >> ~/.bashrc
fi

# Set port 8080 visibility to public using gh CLI (if in Codespaces)
if [ -n "${CODESPACE_NAME:-}" ]; then
    echo "🔓 Setting port 8080 visibility to public..."
    # Check if gh CLI is authenticated before attempting to set port visibility
    if gh auth status &>/dev/null; then
        gh codespace ports visibility 8080:public -c "${CODESPACE_NAME}" 2>/dev/null || echo "⚠️  Could not set port visibility automatically. Please set port 8080 to public manually in the PORTS panel."
    else
        echo "⚠️  gh CLI not authenticated. Please set port 8080 to public manually in the PORTS panel."
    fi
fi

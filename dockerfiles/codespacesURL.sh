#!/usr/bin/env bash
# GitHub Codespaces URL configuration script for Jenkins
# This script configures Jenkins URLs to work with Codespaces port forwarding

set -Eeuo pipefail  # Exit on error, undefined variables, pipe failures

# Resolve repo root and config file dynamically
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
config_file="${REPO_ROOT}/dockerfiles/jenkins.yaml"

# Port configuration (default 8080)
PORT="${PORT:-8080}"

# Check if running in GitHub Codespaces
if [ -n "${CODESPACE_NAME:-}" ] && [ -n "${GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN:-}" ]; then
    # Build Codespaces URL from environment variables
    service_url="https://${CODESPACE_NAME}-${PORT}.${GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN}"
    echo "✅ Detected GitHub Codespaces environment"
else
    # Fallback for local development
    service_url="http://127.0.0.1:${PORT}"
    echo "ℹ️  Running in local environment"
fi

# Define an array of available tutorial profiles
targets=("maven" "node" "python" "multi" "cpp" "dotnet" "golang" "android" "default" "wizard")

# Initialize message string
message="📚 Available tutorial profiles: "

# Build the profiles list message
for target in "${targets[@]}"; do
  message+="\033[36m${target}\033[0m, "
done

# Remove the trailing comma and space
message=${message%??}

# Display information to user
printf "\n"
printf "🚀 Jenkins Quickstart Tutorials Setup\n"
printf "======================================\n"
printf "\n"
printf "Once you run \033[42;30mdocker compose --profile <profile-name> up\033[0m,\n"
printf "Jenkins will be accessible at: \033[36m%s\033[0m\n" "${service_url}"
printf "\n"
printf "%b\n" "${message}"
printf "\n"
printf "Quick start commands:\n"
for target in "${targets[@]}"; do
  printf "  • \033[42;30mdocker compose --profile %s up -d\033[0m - Start %s tutorial\n" "${target}" "${target}"
done
printf "\n"

# Check if jenkins.yaml exists
if [ ! -f "${config_file}" ]; then
    echo "⚠️  Warning: Jenkins configuration file not found at ${config_file}"
    echo "   Configuration will be done when Jenkins starts."
    exit 0
fi

echo "🔧 Updating Jenkins configuration..."

# Verify yq is available
if ! command -v yq &> /dev/null; then
    echo "❌ Error: yq not found. Please install yq to update Jenkins configuration."
    echo "   Jenkins URL may need manual configuration."
    exit 1
fi

# Use yq to update the Jenkins location URL in the configuration file
yq -i ".unclassified.location.url = \"${service_url}/\"" "${config_file}"

# Suppress the Reverse Proxy setup warning for Codespaces
yq -i '.jenkins.disabledAdministrativeMonitors = ["hudson.diagnosis.ReverseProxySetupMonitor"]' "${config_file}"

echo "✅ Jenkins configuration updated successfully"

echo ""
echo "🎉 Setup complete! You're ready to start a tutorial."
echo ""

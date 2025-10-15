#!/bin/bash
# GitHub Codespaces URL configuration script for Jenkins
# This script configures Jenkins URLs to work with Codespaces port forwarding

# Set the path to the configuration file
config_file="/workspaces/quickstart-tutorials/dockerfiles/jenkins.yaml"

# Check if running in GitHub Codespaces
if [ -n "$CODESPACE_NAME" ] && [ -n "$GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN" ]; then
    # Build Codespaces URL from environment variables
    service_url="https://${CODESPACE_NAME}-8080.${GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN}"
    echo "✅ Detected GitHub Codespaces environment"
else
    # Fallback for local development
    service_url="http://127.0.0.1:8080"
    echo "ℹ️  Running in local environment"
fi

# Define an array of available tutorial profiles
targets=("maven" "node" "python" "multi" "cpp" "dotnet" "golang" "android" "default" "wizard")

# Initialize message string
message="📚 Available tutorial profiles: "

# Build the profiles list message
for target in "${targets[@]}"; do
  message+="\033[36m$target\033[0m, "
done

# Remove the trailing comma and space
message=${message%??}

# Display information to user
echo ""
echo "🚀 Jenkins Quickstart Tutorials Setup"
echo "======================================"
echo ""
echo "Once you run \033[42;30mdocker compose --profile <profile-name> up\033[0m,"
echo "Jenkins will be accessible at: \033[36m$service_url\033[0m"
echo ""
echo -e "$message"
echo ""
echo "Quick start commands:"
for target in "${targets[@]}"; do
  echo "  • \033[42;30mdocker compose --profile $target up -d\033[0m - Start $target tutorial"
done
echo ""

# Check if jenkins.yaml exists
if [ ! -f "$config_file" ]; then
    echo "⚠️  Warning: Jenkins configuration file not found at $config_file"
    echo "   Configuration will be done when Jenkins starts."
    exit 0
fi

echo "🔧 Updating Jenkins configuration..."

# Use yq to update the Jenkins location URL in the configuration file
if command -v yq &> /dev/null; then
    yq eval ".unclassified.location.url = \"$service_url/\"" "$config_file" > "$config_file.tmp" && mv "$config_file.tmp" "$config_file"

    # Suppress the Reverse Proxy setup warning for Codespaces
    yq e -i ".jenkins.disabledAdministrativeMonitors = [\"hudson.diagnosis.ReverseProxySetupMonitor\"]" "$config_file"

    echo "✅ Jenkins configuration updated successfully"
else
    echo "⚠️  Warning: yq not found, skipping configuration update"
    echo "   Jenkins URL may need manual configuration"
fi

echo ""
echo "🎉 Setup complete! You're ready to start a tutorial."
echo ""

#!/bin/bash

# Set the path to the configuration file
config_file="/workspace/quickstart-tutorials/dockerfiles/jenkins.yaml"

# Extract the hostname from the GITPOD_WORKSPACE_URL variable
service_url=$(echo "$GITPOD_WORKSPACE_URL" | awk -F/ '{print $3}')

# Print the hostname for debugging purposes
echo -e "Once you enter \033[42;30mdocker compose up _target_\033[0m, Jenkins will be accessible here: \033[36mhttps://8080-$service_url\033[0m"
echo -e "As a gentle reminder, the current targets are: \033[36mmaven\033[0m, \033[36mnode\033[0m, \033[36mpython\033[0m, and \033[36mmulti\033[0m"

# Use yq to update the value of the .unclassified.location.url field in the configuration file
yq eval ".unclassified.location.url = \"https://8080-$service_url/\"" "$config_file" > "$config_file.tmp" && mv "$config_file.tmp" "$config_file"

# Use yq to add a line to suppress the Reverse Proxy setup is broken warning
yq e -i ".jenkins.disabledAdministrativeMonitors = [\"hudson.diagnosis.ReverseProxySetupMonitor\"]" $config_file

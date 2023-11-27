#!/bin/bash

# Set the path to the configuration file
config_file="/workspace/quickstart-tutorials/dockerfiles/jenkins.yaml"

# Extract the hostname from the GITPOD_WORKSPACE_URL variable
service_url=$(echo "$GITPOD_WORKSPACE_URL" | awk -F/ '{print $3}')

# Define an array of targets
targets=("maven" "node" "python" "multi")

# Initialize an empty string for the message
message="As a gentle reminder, the current targets are: "

# Loop over the targets array
for target in "${targets[@]}"; do
  # Append to the message string
  message+="\033[36m$target\033[0m, "
done

# Remove the trailing comma and space
message=${message%??}

# Print the hostname for debugging purposes
echo -e "Once you enter \033[42;30mdocker compose up _target_\033[0m, Jenkins will be accessible here: \033[36mhttps://8080-$service_url\033[0m"
# Print the message
echo -e "$message"
# Loop over the targets array
for target in "${targets[@]}"; do
  echo -e "To start the $target service, enter: \033[42;30mdocker compose up $target\033[0m"
done

# Use yq to update the value of the .unclassified.location.url field in the configuration file
yq eval ".unclassified.location.url = \"https://8080-$service_url/\"" "$config_file" > "$config_file.tmp" && mv "$config_file.tmp" "$config_file"

# Use yq to add a line to suppress the Reverse Proxy setup is broken warning
yq e -i ".jenkins.disabledAdministrativeMonitors = [\"hudson.diagnosis.ReverseProxySetupMonitor\"]" $config_file

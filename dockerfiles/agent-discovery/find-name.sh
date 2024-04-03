#!/bin/bash
# This script is used to find the machine name of a host in a network using nmap.

set -x  # The set -x option enables a mode of the shell where all executed commands are printed to the terminal.

# First of all, let's change the value of the CASC_RELOAD_TOKEN environment variable in the jenkins.yaml file.
# The token has been generated in the keygen.sh script and stored in the jcasc_token file thanks to the sidekick container.
# We list and display the content of the jcasc_token file located in /ssh-dir/secrets/
ls -artl /ssh-dir/secrets/jcasc_token && cat /ssh-dir/secrets/jcasc_token
# We copy the jcasc_token file to /secrets/ directory and display its content
cp /ssh-dir/secrets/jcasc_token /secrets/ && ls -artl /secrets/jcasc_token && cat /secrets/jcasc_token

# Read the content of the jcasc_token file and store it in JCASC_TOKEN variable
JCASC_TOKEN=$(cat /ssh-dir/secrets/jcasc_token)
# Export the JCASC_TOKEN variable to the environment
export JCASC_TOKEN

# Use yq to update the jenkins.yaml file
# We replace the value of CASC_RELOAD_TOKEN key in jenkins.yaml file with the content of JCASC_TOKEN variable
# Loop until the jenkins.yaml file exists
while [ ! -f /var/jenkins_home/jenkins.yaml ]; do
  echo "Waiting for /var/jenkins_home/jenkins.yaml to be created..."
  sleep 2  # Wait for 2 seconds before the next check
done

# Now that the file exists, execute the yq command
yq eval -i '(.jenkins.globalNodeProperties.0.envVars.env[] | select(.key == "CASC_RELOAD_TOKEN")).value = env(JCASC_TOKEN)' /var/jenkins_home/jenkins.yaml

# Display the updated jenkins.yaml file
cat /var/jenkins_home/jenkins.yaml
# Hopefully, Jenkins will load this JCasc configuration after we change the value
# We will modify this file later on with the name of the agent machine, but this change has to happen as soon as possible, so Jenkins knows the token to reload the configuration later on, once we have found the agent machine name.

# Get the IP address of the host machine
# The hostname -I command is used to print all network addresses of the host.
# The awk command is used to print the first field (the first IP address).
IP_ADDRESS=$(hostname -I | awk '{print $1}')

# Get the first three octets of the IP address
# The cut command is used to split the IP address by '.' and print the first three fields.
THREE_OCTETS=$(echo "$IP_ADDRESS" | cut -d '.' -f 1-3)

# Run the nmap command with the appropriate subnet mask and print the output
# The script enters an infinite loop where it continuously scans the network for hosts.
while true; do
  # The nmap -sn command is used to perform a ping scan of the network.
  # The $THREE_OCTETS.0/24 argument specifies the subnet mask for the network scan.
  NMAP_OUTPUT=$(nmap -sn "$THREE_OCTETS".0/24)
  echo "nmap output: $NMAP_OUTPUT"

  # Split the nmap output into lines
  IFS=$'\n' NMAP_LINES=($NMAP_OUTPUT)
  # Search for the line containing "agent"
  for LINE in "${NMAP_LINES[@]}"; do
    if [[ $LINE == *"agent"* ]]; then
      MATCHING_HOST=$LINE
      echo "$MATCHING_HOST"
      # The awk command is used to print the 5th field of the matching line, which should be the machine name.
      MACHINE_NAME=$(echo "$MATCHING_HOST" | awk '{print $5}')
      # Split the machine name by "." and print the first field
      MACHINE_NAME=$(echo "$MACHINE_NAME" | cut -d '.' -f 1)
      echo "Machine name: $MACHINE_NAME"

      # Export the MACHINE_NAME variable to the environment
      export MACHINE_NAME

      # Use yq to update the jenkins.yaml file
      # We replace the host value of the ssh jenkins docker agent node in jenkins.yaml file with the MACHINE_NAME variable
      yq eval -i '(.jenkins.nodes[] | select(.permanent.nodeDescription == "ssh jenkins docker agent ")).permanent.launcher.ssh.host = env(MACHINE_NAME)' /var/jenkins_home/jenkins.yaml

      # Display the updated jenkins.yaml file
      cat /var/jenkins_home/jenkins.yaml

      break 2  # Exit the loop.
    fi
  done

  echo "No matching hosts found, retrying in 2 seconds..."
  sleep 2  # Wait for 5 seconds before the next iteration of the loop.
done

# Check If Jenkins is running or not
# If the message is found, awk exits with a non-zero status (1), and the loop continues.
# If the message is not found, the loop exits, and the "Jenkins is running" message is displayed.
timeout 60 bash -c 'until curl -s -f http://jenkins_controller:8080/login > /dev/null; do sleep 5; done' && echo "Jenkins is running" || echo "Jenkins is not running"
echo "Jenkins is ready"
# Get the Jenkins version
JENKINS_VERSION=$(curl -s -I -k http://admin:admin@jenkins_controller:8080 | grep -i '^X-Jenkins:' | awk '{print $2}')
echo "Jenkins version is: $JENKINS_VERSION"

# Use the token in the curl command to reload the configuration
# curl -X POST "http://admin:admin@jenkins_controller:8080/reload-configuration-as-code/?casc-reload-token=$JCASC_TOKEN"
curl -X POST "http://admin:admin@jenkins_controller:8080/reload-configuration-as-code/?casc-reload-token=thisisnotsecure"

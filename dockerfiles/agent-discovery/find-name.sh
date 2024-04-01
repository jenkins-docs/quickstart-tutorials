#!/bin/bash
# This script is used to find the machine name of a host in a network using nmap.

set -x  # The set -x option enables a mode of the shell where all executed commands are printed to the terminal.

# Get the IP address
# The hostname -I command is used to print all network addresses of the host.
# The awk command is used to print the first field (the first IP address).
IP_ADDRESS=$(hostname -I | awk '{print $1}')

# Get the first three octets of the IP address
# The cut command is used to split the IP address by '.' and print the first three fields.
THREE_OCTETS=$(echo $IP_ADDRESS | cut -d '.' -f 1-3)

# Run the nmap command with the appropriate subnet mask and print the output
# The script enters an infinite loop where it continuously scans the network for hosts.
while true; do
  # The nmap -sn command is used to perform a ping scan of the network.
  # The $THREE_OCTETS.0/24 argument specifies the subnet mask for the network scan.
  NMAP_OUTPUT=$(nmap -sn $THREE_OCTETS.0/24)
  echo "nmap output: $NMAP_OUTPUT"

  # Split the nmap output into lines
  IFS=$'\n' NMAP_LINES=($NMAP_OUTPUT)

  # Search for the line containing "agent"
  for LINE in "${NMAP_LINES[@]}"; do
    if [[ $LINE == *"agent"* ]]; then
      MATCHING_HOST=$LINE
      echo "$MATCHING_HOST"
      # The awk command is used to print the 5th field of the matching line, which should be the machine name.
      MACHINE_NAME=$(echo $MATCHING_HOST | awk '{print $5}')
      # Split the machine name by "." and print the first field
      MACHINE_NAME=$(echo $MACHINE_NAME | cut -d '.' -f 1)
      echo "Machine name: $MACHINE_NAME"

      # Export the MACHINE_NAME variable to the environment
      export MACHINE_NAME

      # Use yq to update the jenkins.yaml file
      cat /var/jenkins_home/jenkins.yaml

      yq eval -i '(.jenkins.nodes[] | select(.permanent.nodeDescription == "ssh jenkins docker agent ")).permanent.launcher.ssh.host = env(MACHINE_NAME)' /var/jenkins_home/jenkins.yaml

      cat /var/jenkins_home/jenkins.yaml

      break 2  # Exit the loop.
    fi
  done

  echo "No matching hosts found, retrying in 2 seconds..."
  sleep 2  # Wait for 5 seconds before the next iteration of the loop.
done

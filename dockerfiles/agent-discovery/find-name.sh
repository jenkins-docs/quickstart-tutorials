#!/bin/bash
set -x

# Get the IP address
IP_ADDRESS=$(hostname -I | awk '{print $1}')

# Get the first three octets of the IP address
THREE_OCTETS=$(echo $IP_ADDRESS | cut -d '.' -f 1-3)

# Run the nmap command with the appropriate subnet mask and print the output
while true; do
  NMAP_OUTPUT=$(nmap -sn $THREE_OCTETS.0/24)
  echo "nmap output: $NMAP_OUTPUT"

  MATCHING_HOST=$(echo $NMAP_OUTPUT | grep "agent" || true)
  if [ -n "$MATCHING_HOST" ]; then
    echo "$MATCHING_HOST"
    break
  else
    echo "No matching hosts found, retrying in 5 seconds..."
    sleep 5
  fi
done

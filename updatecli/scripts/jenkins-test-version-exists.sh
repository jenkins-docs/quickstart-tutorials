#!/bin/bash

# Get the URL from the command line arguments
URL="$1"

# Print the URL
echo "URL: ${URL}"

# Use curl to get the HTTP status code
HTTP_STATUS=$(curl -o /dev/null -s -w "%{http_code}\n" "${URL}")

# Print the HTTP status code
echo "HTTP status: ${HTTP_STATUS}"

# Check if the status code starts with '2' or is '302' (i.e., it's a 20x status code or a redirection)
if [[ "${HTTP_STATUS}" == 2* ]] || [[ "${HTTP_STATUS}" == 30* ]]; then
  # If it does, exit with a zero status code
  exit 0
else
  # If it doesn't, exit with a non-zero status code
  exit 1
fi

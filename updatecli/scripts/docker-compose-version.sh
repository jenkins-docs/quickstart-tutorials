#!/bin/bash

# Read the docker-versions.txt file
file_content=$(cat docker-versions.txt)

# Use grep to find the line with "- Docker Compose version"
# Then, use cut to split the line by spaces and get the 5th field (the version)
docker_compose_version=$(echo "$file_content" | grep -- "- Docker Compose version" | cut -d ' ' -f 5)

# Get the current version from README.md (strip leading 'v' if present for comparison)
current_version=$(grep -oP 'Docker Compose version `\K[^`]+' README.md | head -n1)

# Strip leading 'v' for comparison (updatecli trimprefix transformer handles the output)
new_clean=$(echo "$docker_compose_version" | sed 's/^v//')
current_clean=$(echo "$current_version" | sed 's/^v//')

# Compare versions: only output the new version if it's strictly newer
if [ -n "$current_clean" ] && [ -n "$new_clean" ]; then
  newer=$(printf '%s\n%s' "$new_clean" "$current_clean" | sort -V | tail -n1)
  if [ "$newer" = "$current_clean" ] || [ "$new_clean" = "$current_clean" ]; then
    # Current version is same or newer, output it unchanged to avoid a downgrade
    echo "v${current_clean}"
    exit 0
  fi
fi

# Print the Docker Compose version (new or when no current version found)
echo "$docker_compose_version"

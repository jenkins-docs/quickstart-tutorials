#!/bin/bash

# Read the docker-versions.txt file
file_content=$(cat docker-versions.txt)

# Use grep to find the line with "- Docker version"
# Then, use cut to split the line by spaces and get the 4th field (the version)
docker_version=$(echo "$file_content" | grep -- "- Docker version" | cut -d ' ' -f 4)

# Cut the version string at the comma to get only the semver part
docker_version=$(echo "$docker_version" | cut -d ',' -f 1)

# Get the current version from README.md
current_version=$(grep -oP 'Docker version `\K[^`]+' README.md | head -n1)

# Compare versions: only output the new version if it's strictly newer
if [ -n "$current_version" ] && [ -n "$docker_version" ]; then
  newer=$(printf '%s\n%s' "$docker_version" "$current_version" | sort -V | tail -n1)
  if [ "$newer" = "$current_version" ] || [ "$docker_version" = "$current_version" ]; then
    # Current version is same or newer, output it unchanged to avoid a downgrade
    echo "$current_version"
    exit 0
  fi
fi

# Print the Docker version (new or when no current version found)
echo "$docker_version"

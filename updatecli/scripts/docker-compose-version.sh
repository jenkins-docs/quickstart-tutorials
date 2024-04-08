#!/bin/bash

# Read the docker-versions.txt file
file_content=$(cat docker-versions.txt)

# Use grep to find the line with "- Docker Compose version"
# Then, use cut to split the line by spaces and get the 5th field (the version)
docker_compose_version=$(echo "$file_content" | grep -- "- Docker Compose version" | cut -d ' ' -f 5)

# Print the Docker Compose version
echo $docker_compose_version

#!/bin/bash

# Read the docker-versions.txt file
file_content=$(cat docker-versions.txt)

# Use grep to find the line with "- Docker version"
# Then, use cut to split the line by spaces and get the 4th field (the version)
docker_version=$(echo "$file_content" | grep -- "- Docker version" | cut -d ' ' -f 4)

# Cut the version string at the comma to get only the semver part
docker_version=$(echo "$docker_version" | cut -d ',' -f 1)

# Print the Docker version
echo $docker_version

#!/bin/bash
set -e

original_file="docker-compose.yaml"

# Function to add a service and its dependencies to the included_services list
add_service_and_dependencies() {
    local service=$1
    # Mark the service as included
    included_services["$service"]=1
    # Check if the service has dependencies
    if yq e ".services.${service}.depends_on" "$original_file" -e > /dev/null; then
        # Read dependencies of the service
        local dependencies=($(yq e ".services.${service}.depends_on | keys" "$original_file" -o json | jq -r '.[]'))
        # Recursively add dependencies
        for dependency in "${dependencies[@]}"; do
            if [[ -z "${included_services["$dependency"]}" ]]; then
                add_service_and_dependencies "$dependency"
            fi
        done
    fi
}

# Step 1: Collect all dependencies
declare -A all_dependencies
services=$(yq e '.services | keys' "$original_file" -o json | jq -r '.[]')
for service in $services; do
    dependencies=$(yq e ".services.$service.depends_on | keys" "$original_file" -o json | jq -r '.[]')
    for dependency in $dependencies; do
        all_dependencies["$dependency"]=1
    done
done

# Step 2: Process each profile and include dependencies
for profile in $(yq e '.services[].profiles[]?' "$original_file" | sort -u); do
    echo "Processing profile: $profile"
    # Initialize an associative array to track included services
    declare -A included_services
    # Find and include services matching the profile
    matching_services=$(yq e ".services | with_entries(select(.value.profiles[]? == \"$profile\")) | keys" "$original_file" -o json | jq -r '.[]')
    for service in $matching_services; do
        add_service_and_dependencies "$service"
    done
    # Correctly format the list of included services for yq query
    included_services_keys=$(printf "'%s'," "${!included_services[@]}")
    included_services_keys="[${included_services_keys%,}]" # Remove trailing comma and wrap in brackets

    # Generate the docker-compose file for the profile
    echo "Generating docker-compose-$profile.yaml"
    yq e ".services | with_entries(select(.key as \$k | .key == \"$included_services_list\"))" "$original_file" > "docker-compose-$profile.yaml"
done

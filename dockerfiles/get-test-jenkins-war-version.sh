#!/bin/bash

# Get the directory of the current script
SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"

# Source the common functions
source "${SCRIPT_DIR}/test-jenkins-war-commons.sh"

# Get the JSON response
JSON_RESPONSE=$(get_json_response)

# Get the relative path of the Jenkins war file
ARTIFACT_RELATIVE_PATH=$(get_war_relative_path "${JSON_RESPONSE}")

# Get the version from the Jenkins war file's relative path
WAR_VERSION=$(get_war_version "${ARTIFACT_RELATIVE_PATH}")

# Print the version
echo "${WAR_VERSION}"

#!/bin/bash

# Get the directory of the current script
SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"

# Source the common functions
source "${SCRIPT_DIR}/test-jenkins-war-commons.sh"

# Get the JSON response
JSON_RESPONSE=$(get_json_response)

# Print the JSON response
# echo "JSON response: ${JSON_RESPONSE}"

# Get the relative path of the Jenkins war file
ARTIFACT_RELATIVE_PATH=$(get_war_relative_path "${JSON_RESPONSE}")

# Print the relative path
# echo "Relative path: ${ARTIFACT_RELATIVE_PATH}"

# Construct the URL of the artifact
ARTIFACT_URL="${JENKINS_JOB_URL}/lastSuccessfulBuild/artifact/${ARTIFACT_RELATIVE_PATH}"

# Print the URL
#echo "Artifact URL: ${ARTIFACT_URL}"
echo "${ARTIFACT_URL}"

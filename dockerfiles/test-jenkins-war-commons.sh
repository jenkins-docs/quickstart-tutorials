#!/bin/bash

# Source the .env file
if [ -f .env ]; then
    source .env
fi

# Check if JENKINS_USERNAME and JENKINS_API_TOKEN are set
if [[ -z "${JENKINS_USERNAME}" ]] || [[ -z "${JENKINS_API_TOKEN}" ]]; then
    echo "Error: JENKINS_USERNAME and JENKINS_API_TOKEN must be set in the environment."
    env
    exit 1
fi

# Jenkins job URL
export JENKINS_JOB_URL="https://ci.jenkins.io/job/Core/job/jenkins/job/jakarta"

# Function to get the JSON response from the Jenkins REST API for the last successful build
get_json_response() {
  curl --user "${JENKINS_USERNAME}:${JENKINS_API_TOKEN}" --silent "${JENKINS_JOB_URL}/lastSuccessfulBuild/api/json"
}

# Function to get the relative path of the Jenkins war file from the JSON response
get_war_relative_path() {
  echo "${1}" | jq -r '.artifacts[] | select(.fileName | endswith(".war")) | .relativePath'
}

# Function to get the version from the Jenkins war file's relative path
get_war_version() {
  echo "${1}" | cut -d'/' -f5
}

#!/bin/bash

# Jenkins username and API token
export JENKINS_USERNAME="poddingue"
export JENKINS_API_TOKEN="11d4546072384822ba23c4721716e82f6c"

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

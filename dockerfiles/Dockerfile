# Dockerfile for setting up a Jenkins environment with a specific version and pre-configured settings.

# Define the Jenkins version to use for the base image.
ARG JENKINS_VERSION=2.473-jdk17

# Use the official Jenkins Docker image with the specified version.
FROM jenkins/jenkins:${JENKINS_VERSION}

# Define a specific Jenkins test version for testing purposes.
ARG JENKINS_TEST_VERSION=2.475-rc35284.fdc46ed187c8
# Make the Jenkins test version available as an environment variable.
ENV JENKINS_TEST_VERSION=$JENKINS_TEST_VERSION

# Define the URL for downloading the Jenkins WAR file for the test version.
ARG JENKINS_TEST_WAR_URL=https://ci.jenkins.io/job/Core/job/jenkins/job/jakarta/lastSuccessfulBuild/artifact/org/jenkins-ci/main/jenkins-war/"$JENKINS_TEST_VERSION"/jenkins-war-"$JENKINS_TEST_VERSION".war
# Make the Jenkins WAR URL available as an environment variable.
ENV JENKINS_TEST_WAR_URL=$JENKINS_TEST_WAR_URL

# Copy any scripts named *test*sh from the build context to /usr/local/bin/ inside the image.
COPY *test*sh /usr/local/bin/

# Switch to the root user to perform operations requiring elevated privileges.
USER root

# Update the package index and install jq for processing JSON.
RUN apt-get update && apt-get install -y jq

# Download the Jenkins WAR file specified by JENKINS_TEST_WAR_URL and replace the existing WAR file.
RUN chmod +x /usr/local/bin/*.sh && \
        curl -L "$JENKINS_TEST_WAR_URL" -o /usr/share/jenkins/jenkins.war

# Copy the jobs directory from the build context to /var/jenkins_home/jobs inside the image.
# This pre-configures Jenkins with certain jobs.
COPY jobs /var/jenkins_home/jobs

# Change the ownership of the /var/jenkins_home/jobs directory to the jenkins user.
# This ensures Jenkins can access and manage these jobs.
RUN chown -R jenkins:jenkins /var/jenkins_home/jobs

# Switch back to the jenkins user for security reasons and to run Jenkins.
USER jenkins

# Write the Jenkins test version to the UpgradeWizard state file to prevent the upgrade wizard from showing up.
RUN echo "${JENKINS_TEST_VERSION}" > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state

# Copy the plugins.txt file from the build context to /usr/share/jenkins/ref/plugins.txt inside the image.
# This file lists the plugins to be installed in Jenkins.
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt.override

# Use the Jenkins plugin CLI to install the plugins listed in plugins.txt.
RUN ln -s /usr/share/jenkins/ref/plugins.txt.override /usr/share/jenkins/ref/plugins.txt && jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt

# Copy a pre-configured Jenkins configuration file (jenkins.yaml) to /usr/share/jenkins/ref/jenkins.yaml inside the image.
# This file contains settings for Jenkins.
COPY jenkins.yaml /usr/share/jenkins/ref/jenkins.yaml.override

# We start by defining an ARG for the Jenkins version. This allows us to easily change the version of Jenkins we want to use.
ARG JENKINS_VERSION=2.466-jdk17
# We start by defining an ARG for the Jenkins version. This allows us to easily change the version of Jenkins we want to use.
ARG JENKINS_TEST_VERSION=2.468-rc35117.17e6a_5d39c04

# We then use the official Jenkins image with the specified version as our base image.
FROM jenkins/jenkins:"${JENKINS_VERSION}"

ARG JENKINS_TEST_WAR_URL=https://ci.jenkins.io/job/Core/job/jenkins/job/jakarta/lastSuccessfulBuild/artifact/org/jenkins-ci/main/jenkins-war/"${JENKINS_TEST_VERSION}"/jenkins-war-"${JENKINS_TEST_VERSION}".war
# Define JENKINS_TEST_WAR_URL as an ENV
ENV JENKINS_TEST_WAR_URL=${JENKINS_TEST_WAR_URL}

COPY *test*sh /usr/local/bin/

# We switch to the root user to have the necessary permissions for the upcoming operations.
USER root

RUN apt-get update && apt-get install -y jq

# Download the desired Jenkins war file and replace the existing one
RUN chmod +x /usr/local/bin/*.sh && \
        curl -L "$JENKINS_TEST_WAR_URL" -o /usr/share/jenkins/jenkins.war

# We copy the jobs directory from our current directory to the Jenkins home directory in the image.
# This allows us to pre-configure Jenkins with some jobs.
COPY jobs /var/jenkins_home/jobs

# We change the ownership of the jobs directory to the Jenkins user.
# This ensures that the Jenkins server can access and manage the jobs.
RUN chown -R jenkins:jenkins /var/jenkins_home/jobs

# We switch back to the Jenkins user for the remaining operations.
USER jenkins

# We write the Jenkins version to the UpgradeWizard state file.
# This prevents the Upgrade Wizard from showing up when Jenkins starts.
RUN echo "${JENKINS_TEST_VERSION}" > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state

# We copy a list of plugins to install to the Jenkins ref directory in the image.
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt

# We use the Jenkins plugin CLI to install the plugins listed in the plugins.txt file.
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt

# We copy a pre-configured Jenkins configuration file to the Jenkins ref directory in the image.
# This allows us to pre-configure Jenkins with our desired settings.
COPY jenkins.yaml /usr/share/jenkins/ref/jenkins.yaml

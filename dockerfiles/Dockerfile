# This Dockerfile is used to create a Jenkins server with a specific version and pre-configured settings.

# We start by defining an ARG for the Jenkins version. This allows us to easily change the version of Jenkins we want to use.
ARG JENKINS_VERSION=2.426.3

# We then use the official Jenkins image with the specified version as our base image.
FROM jenkins/jenkins:"${JENKINS_VERSION}"

# We switch to the root user to have the necessary permissions for the upcoming operations.
USER root

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
RUN echo "${JENKINS_VERSION}" > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state

# We copy a list of plugins to install to the Jenkins ref directory in the image.
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt

# We use the Jenkins plugin CLI to install the plugins listed in the plugins.txt file.
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt

# We copy a pre-configured Jenkins configuration file to the Jenkins ref directory in the image.
# This allows us to pre-configure Jenkins with our desired settings.
COPY jenkins.yaml /usr/share/jenkins/ref/jenkins.yaml

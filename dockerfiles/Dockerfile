ARG JENKINS_VERSION=2.414.2-lts
FROM jenkins/jenkins:"${JENKINS_VERSION}"
USER root
# Adding jobs directory, with demo job 
COPY jobs /var/jenkins_home/jobs
RUN chown -R jenkins:jenkins /var/jenkins_home/jobs
USER jenkins
RUN echo "${JENKINS_VERSION}" > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt
COPY jenkins.yaml /usr/share/jenkins/ref/jenkins.yaml

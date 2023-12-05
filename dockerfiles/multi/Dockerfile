FROM jenkins/ssh-agent:5.21.0 as ssh-agent
# ca-certificates because curl will need it later on for the Maven installation
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates curl && apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# Installing curl 
RUN apt-get update && apt-get install -y curl

# Installing nodejs
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && apt-get install -y nodejs


# Set SHELL flags for RUN commands to allow -e and pipefail
# Rationale: https://github.com/hadolint/hadolint/wiki/DL4006
SHELL ["/bin/bash", "-eo", "pipefail", "-c"]

RUN echo "PATH=${PATH}" >> /etc/environment && chown -R jenkins:jenkins "${JENKINS_AGENT_HOME}"


# Use the base image
FROM jenkins/ssh-agent:5.16.0 as ssh-agent

# Install necessary Dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    binutils ca-certificates curl git python3 python3-pip python3-setuptools python3-wheel python3-dev wget

# Create an alias for python3 as python
RUN ln -s /usr/bin/python3 /usr/bin/python

# Install required python packages
RUN pip install docker-py feedparser nosexcover prometheus_client pycobertura pylint pytest pytest-cov requests setuptools sphinx pyinstaller

# Add the Jenkins agent user to the environment
RUN echo "PATH=${PATH}" >> /etc/environment

# Set ownership for Jenkins agent home directory
RUN chown -R jenkins:jenkins "${JENKINS_AGENT_HOME}"

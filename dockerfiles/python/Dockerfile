# This Dockerfile is used to create a Jenkins SSH agent with Python and several Python packages installed in order to run the python sample tutorial.

# We start from the Jenkins SSH agent image version 5.20.0.
FROM jenkins/ssh-agent:5.31.0 as ssh-agent

# The RUN command executes a series of commands in the new layer of the image and commits the results.
# The following commands are executed:

# 1. Update the package list.
# 2. Install necessary dependencies including Python, python3-venv and several Python-related packages.
RUN apt-get update && apt-get install -y --no-install-recommends \
    binutils ca-certificates curl git python3 python3-venv python3-pip python3-setuptools python3-wheel python3-dev wget \
    && rm -rf /var/lib/apt/lists/*

# Create an alias for python3 as python.
RUN ln -s /usr/bin/python3 /usr/bin/python

# Create a Python virtual environment in /opt/venv.
RUN python3 -m venv /opt/venv

# Activate the virtual environment by adding its bin directory to the PATH.
# This ensures that the virtual environment is activated for all subsequent RUN commands in the Dockerfile.
ENV PATH="/opt/venv/bin:$PATH"

# Install required Python packages in the virtual environment.
RUN pip install docker-py feedparser nosexcover prometheus_client pycobertura pylint pytest pytest-cov requests setuptools sphinx pyinstaller

# Add the PATH environment variable to /etc/environment so that it is available to all users and processes.
RUN echo "PATH=${PATH}" >> /etc/environment

# Set the ownership of the Jenkins agent home directory to the Jenkins user.
# This ensures that the Jenkins user has the necessary permissions to access its home directory.
RUN chown -R jenkins:jenkins "${JENKINS_AGENT_HOME}"

FROM jenkins/ssh-agent:6.14.0-jdk21

# Install necessary C++ build tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    gcc \
    g++ \
    clang \
    make \
    libstdc++-12-dev \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV PATH="/usr/local/bin:$PATH"

# Ensure the ownership of the Jenkins agent home directory is set to the Jenkins user
RUN chown -R jenkins:jenkins "${JENKINS_AGENT_HOME}"

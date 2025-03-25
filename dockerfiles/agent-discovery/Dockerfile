# This Dockerfile is used to prepare a Debian-based Docker image with several utilities installed.

# We start from the Debian 'bookworm' image dated 2023-11-20.
FROM debian:bookworm-20250317-slim as prepare-stage

# Copy all shell scripts from the current directory to /usr/local/bin/ in the image.
COPY *sh /usr/local/bin/

# Make all shell scripts in /usr/local/bin/ executable.
RUN chmod +x /usr/local/bin/*.sh

# The RUN command executes a series of commands in the new layer of the image and commits the results.
# The following commands are executed:

# 1. Update the package list.
# 2. Install necessary dependencies including several utilities and remove the package list to reduce the image size.
RUN apt update && apt install -y --no-install-recommends \
    ca-certificates \
    curl \
    jq \
    nmap \
    && rm -rf /var/lib/apt/lists/* && rm -fr /tmp/*

# Install the correct version of yq based on the architecture
RUN if [ "$(uname -m)" = "aarch64" ]; then \
        curl -L https://github.com/mikefarah/yq/releases/download/v4.13.5/yq_linux_arm64 -o /usr/bin/yq; \
    else \
        curl -L https://github.com/mikefarah/yq/releases/download/v4.13.5/yq_linux_amd64 -o /usr/bin/yq; \
    fi && chmod +x /usr/bin/yq

# The CMD command specifies the default command to execute when the container starts.
# In this case, it prints a message and lists the contents of /ssh-dir.
CMD ["sh", "-c", "echo 'Stage is ready'; ls -l /var/jenkins_home/"]

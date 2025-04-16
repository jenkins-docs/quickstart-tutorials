FROM jenkins/ssh-agent:6.12.0-jdk21 AS ssh-agent

# install dotnet dependencies
RUN apt-get update && apt-get install -y --no-install-recommends libc6 libgcc1 libgssapi-krb5-2 libicu72 libssl3 libstdc++6 zlib1g wget && apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# Now time to install dotnet
ARG DOTNET_VERSION=8.0

# Set SHELL flags for RUN commands to allow -e and pipefail
# Rationale:https://github.com/hadolint/hadolint/wiki/DL4006
SHELL ["/bin/bash", "-eo", "pipefail", "-c"]

RUN wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh && chmod +x ./dotnet-install.sh && \
    ./dotnet-install.sh --channel ${DOTNET_VERSION} --install-dir /usr/local/dotnet

ENV DOTNET_ROOT=/usr/local/dotnet
ENV PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools

RUN echo "PATH=${PATH}" >> /etc/environment && chown -R jenkins:jenkins "${JENKINS_AGENT_HOME}" && \
    dotnet --list-sdks


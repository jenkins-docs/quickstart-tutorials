FROM debian:bookworm-20231120 as prepare-stage

COPY *sh /usr/local/bin/

RUN chmod +x /usr/local/bin/*.sh

RUN apt update && apt install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    gnupg \
    nano \
    openssh-client \
    procps \
    unzip \
    wget \
    && rm -rf /var/lib/apt/lists/*

RUN /usr/local/bin/keygen.sh /ssh-dir

CMD ["sh", "-c", "echo 'Export stage is ready'; ls -l /ssh-dir/"]

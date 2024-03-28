# This Dockerfile is used to create a Gitpod workspace with GitHub CLI installed.

# We start from the Gitpod full workspace image which includes a broad range of development tools.
FROM gitpod/workspace-full:2024-03-27-12-29-58

# The RUN command executes a series of commands in the new layer of the image and commits the results.
# The following commands are executed:

# 1. Check if curl is installed. If not, update the package list and install curl.
# 2. Download the GPG key for the GitHub CLI repository and save it to a specific location.
# 3. Change the permissions of the GPG key file to make it readable for all users.
# 4. Add the GitHub CLI repository to the list of APT sources.
# 5. Update the package list again to include packages from the newly added repository.
# 6. Install the GitHub CLI (gh).
# 7. Clean up the APT cache to reduce the size of the image.
# 8. Remove unnecessary files and directories to further reduce the size of the image.
RUN type -p curl >/dev/null || (sudo apt update && sudo apt install curl -y) && \
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg && \
    sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
    sudo apt update && \
    sudo apt install gh -y && \
    sudo apt-get clean && \
    sudo rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

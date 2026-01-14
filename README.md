# Jenkins Tutorial Files

This repository includes the files necessary for transitioning from `docker` to `docker compose` in our Jenkins tutorials and installation guides.

### How to Set Up the Repository in GitHub Codespaces? (Recommended)

GitHub Codespaces provides a cloud-based development environment with Docker pre-installed and configured.

#### Quick Start
1. Click the button below to open this repository in GitHub Codespaces:

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/jenkins-docs/quickstart-tutorials)

2. Wait for the Codespace to build (first time: ~2-3 minutes, subsequent starts: ~30 seconds)
3. Once ready, the setup script will automatically install required tools
4. Follow the instructions in the terminal to start a tutorial

#### What's Included?
- Docker and Docker Compose pre-installed
- `yq` YAML processor for configuration
- GitHub CLI (`gh`) for repository operations
- Automatic port forwarding for Jenkins (8080) and applications (3000, 5000)
- Jenkins URL automatically configured for Codespaces environment

#### Free Tier
- 60 hours/month for free accounts (sufficient for all tutorials)
- 120 hours/month with [GitHub Student Developer Pack](https://education.github.com/pack)

## Cloud Development Environments

### GitHub Codespaces

GitHub Codespaces is a cloud-based development environment integrated with GitHub. It provides instant, configured development environments with Docker pre-installed, making it perfect for these Jenkins tutorials.

**Benefits:**
- No local installation required
- Consistent environment for all users
- Free tier: 60 hours/month
- Accessible from any device with a browser
- Automatic backups via GitHub

### Steps to Run Examples from the Repository

- Use `docker compose up` to run examples from this project. Currently, we have four working examples:
    - maven
    - node
    - python
    - multibranch pipeline

- To run different examples with `docker compose up -d`, append the example name to the command, like so:
    - `maven` => `docker compose --profile maven up -d`
    - `python` => `docker compose --profile python up -d`
    - `node` => `docker compose --profile node up -d`
    - `multi` => `docker compose --profile  multi up -d`

- If no tutorial-related argument is used (i.e., `docker compose --profile default up -d`), the command runs the latest default example.
- If no argument regarding profiles is used at all (i.e., `docker compose up -d`), then you will have a Jenkins controller desperately waiting for a non existent agent to connect.

- If you prefer to build images yourself, append `-f build-docker-compose.yaml` after `docker compose`. For example, to build the `node` tutorial Jenkins instance, use: `docker compose -f build-docker-compose.yaml --profile node up -d`.

### How to Verify Jenkins Installation

- Check the status of the container with the `docker ps` or `docker compose ps` commands.
- Access your running Jenkins instance at [http://127.0.0.1:8080](http://127.0.0.1:8080).
- On GitHub Codespaces, port 8080 is automatically forwarded and you'll see a notification to open the forwarded port in your browser.

### Clean Up Instructions

- To stop and remove running containers, use `docker compose --profile <tutorial-name> down`.
- If you encounter a `Resource is still in use` warning, use the `--remove-orphans` option which would give `docker compose --profile <tutorial-name> down --remove-orphans`.
- To remove the created volumes (should you need to restart from scratch), add the `-v` option which would give `docker compose --profile <tutorial-name> down -v`.

### Jenkins Configuration using JCASC

This repository uses Jenkins Configuration as Code ([JCASC](https://www.jenkins.io/projects/jcasc/)) to provide pre-configured Jenkins environments. The configuration includes:

- Pre-configured admin credentials (admin/admin)
- Automatic agent registration via SSH
- Suppressed reverse proxy warnings for cloud development environments

For more detailed information about the configuration, please refer to `dockerfiles/jenkins.yaml`.

### Encountering Issues?

If you encounter any issues while running the examples, please open an issue [in this repository](https://github.com/jenkins-docs/quickstart-tutorials/issues/new/choose).
We will be happy to help you resolve the issue.
Please let us know the following details when you open an issue:
- The command you used to run the example.
- The error message you received.
- The steps you took before encountering the issue.
- The version of docker you're using via the `docker version` command.
- The version of docker compose you're using via the `docker compose version` command.

The tutorials have been tested with:
- Docker version `28.0.4`
- Docker Compose version `2.38.2`

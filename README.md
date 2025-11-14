# Jenkins Tutorial Files

This repository includes the files necessary for transitioning from `docker` to `docker compose` in our Jenkins tutorials and installation guides.

### How to Set Up the Repository in GitHub Codespaces? (Recommended)

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/jenkins-docs/quickstart-tutorials)

**Benefits:**
- No local installation required
- Consistent environment for all users
- Free tier: 60 hours/month
- Accessible from any device with a browser

**Quick Start:**
1. Click the badge above or the green "Code" button → "Codespaces" tab
2. Click "Create codespace on main"
3. Wait for the environment to initialize (~2-3 minutes)
4. Follow the welcome message in the terminal to start a tutorial

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

### Clean Up Instructions

- To stop and remove running containers, use `docker compose --profile <tutorial-name> down`.
- If you encounter a `Resource is still in use` warning, use the `--remove-orphans` option which would give `docker compose --profile <tutorial-name> down --remove-orphans`.
- To remove the created volumes (should you need to restart from scratch), add the `-v` option which would give `docker compose --profile <tutorial-name> down -v`.

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
- Docker version `26.1.3`
- Docker Compose version `2.27.1`

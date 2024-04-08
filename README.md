# Jenkins Tutorial Files

This repository includes the files necessary for transitioning from `docker` to `docker compose` in our Jenkins tutorials and installation guides.

### How to Set Up the Repository in Gitpod?

- To initialize your Gitpod workspace, prepend `gitpod.io/#` to any GitHub, GitLab, or Bitbucket repository URL.
- Access our Gitpod workspace [here](https://gitpod.io/#https://github.com/jenkins-docs/quickstart-tutorials).
- If you plan to use Gitpod regularly, we recommend installing the Gitpod extension. This extension adds a Gitpod button to every GitHub repository you visit, making it easy to launch a workspace. You can find the extension [here](https://chrome.google.com/webstore/detail/gitpod-online-ide/dodmmooeoklaejobgleioelladacbeki) for Chromium and [here](https://addons.mozilla.org/firefox/addon/gitpod/) for Firefox.

## Gitpod

Gitpod is a cloud-based development environment designed for teams. It supports various IDEs, including VScode, IntelliJ, and many more, enabling efficient and secure software development.

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

- If you prefer to build images yourself, append `-f build-docker-compose.yaml` after `docker compose`. For example, to build the `node` tutorial Jenkins instance, use: `docker compose -f build-docker-compose.yaml up -d node`.

### How to Verify Jenkins Installation

- Check the status of the container with the `docker ps` or `docker compose ps` commands.
- Access your running Jenkins instance at [http://127.0.0.1:8080](http://127.0.0.1:8080).
- On Gitpod, if containers are running successfully after entering `docker compose up <tutorial-name>`, a pop-up titled `A service is available on port 8080` should appear. If it doesn't, you can view the running service in the `PORTS` section on the right side of the terminal.

### Clean Up Instructions

- To stop and remove running containers, use `docker compose down`.
- If you encounter a `Resource is still in use` warning, use the `--remove-orphans` option which would give `docker compose down --remove-orphans`.
- To remove the created volumes (should you need to restart from scratch), add the `-v` option which would give `docker compose down -v`.

### Suppressing Jenkins Warning using JCASC

To improve the Gitpod experience with Jenkins, we've suppressed a reverse proxy setup warning in Jenkins that was causing issues in the Gitpod environment. We achieved this using Jenkins Configuration as Code ([JCASC](https://www.jenkins.io/projects/jcasc/)) and added the following property to the JCASC YAML file:

```yaml
jenkins:
  disabledAdministrativeMonitors:
    - "hudson.diagnosis.ReverseProxySetupMonitor"
```

For more detailed information about this configuration and the context behind it, please refer to the [corresponding issue](https://github.com/ash-sxn/GSoC-2023-docker-based-quickstart/issues/61).

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
- Docker version `24.0.9`
- Docker Compose version `2.23.3`

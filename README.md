# Jenkins tutorial files

Including the files for the transition from `docker` to `docker compose` for Jenkins tutorials and Jenkins installation.

### How to set up the repo in Gitpod?

* For starting your gitpod workspace you can use `gitpod.io/#` as a prefix on any GitHub, gitlab, or bitbucket repo URL
* For our repo you can get the Gitpod workspace from [here](https://gitpod.io/#https://github.com/jenkins-docs/quickstart-tutorials)
* But If you do plan to use Gitpod in the future,
  it's recommended
  to install the Gitpod extension which will create a launch with the Gitpod button on every GitHub repo you visit.
  It can be found [here](https://chrome.google.com/webstore/detail/gitpod-online-ide/dodmmooeoklaejobgleioelladacbeki) for Chromium and [here](https://addons.mozilla.org/firefox/addon/gitpod/) for Firefox.

## Gitpod

- Gitpod is a cloud development environment designed for teams to efficiently and securely develop software.
- Gitpod supports various IDEs, including VScode, IntelliJ, and many more.

### How to Set Up the Repository in Gitpod?

- To initialize your Gitpod workspace, use `gitpod.io/#` as a prefix on any GitHub, GitLab, or Bitbucket repo URL.
- For our repository, you can access the Gitpod workspace [here](https://gitpod.io/#https://github.com/jenkins-docs/quickstart-tutorials).
- If you plan to use Gitpod in the future, it's recommended to install the Gitpod extension.
This extension will create a launch with the Gitpod button on every GitHub repo you visit.
You can find it [here](https://chrome.google.com/webstore/detail/gitpod-online-ide/dodmmooeoklaejobgleioelladacbeki) for Chromium and [here](https://addons.mozilla.org/firefox/addon/gitpod/) for Firefox.

### Steps to Run Examples from the Repository

- Use `docker compose up` to run examples from the project.
    - There are currently six working examples in the project:
        - 00_old_one_from_proposal
        - 01_simple_controller_plus_agent
        - 02_custom_docker_file_connecting_agent_and_controller
        - 03_maven_tutorial
        - 04_python_tutorial
        - 05_nodejs
        - 06_multibranch_pipeline
- Each example has a `README` file providing manual instructions for running them.

- To run different examples with `docker compose up -d`, add these arguments to the command:
    - `maven` - 03_maven_tutorial => `docker compose up -d maven`
    - `python` - 04_python-tutorial => `docker compose up -d python`
    - `node` - 05_nodejs => `docker compose up -d node`
    - `multi` - 06_multibranch_pipeline => `docker compose up -d multi`

- If no argument is used (i.e., `docker compose up -d`), it runs the latest default example.

- If you want to build images yourself, add `-f build-docker-compose.yaml` after `docker compose`.
The command should resemble something like this: `docker compose -f build-docker-compose.yaml up -d node` to build the Node Tutorial.

### How to Verify Jenkins Installation

- Check the status of the container with the `docker ps` command or the `docker compose ps` command.
- Access your running Jenkins at [http://127.0.0.1:8080](http://127.0.0.1:8080).
- On Gitpod, if containers are running successfully, you should see a pop-up titled `A service is available on port 8080`.
If it doesn't appear, you can view the running service in the `PORTS` section on the right part of the terminal.

### Clean Up Instructions

- To stop and remove the running containers, use `docker compose down`.
- If you get a `Resource is still in use` warning, the `--remove-orphans` option can be used to resolve this.
- You can also add the `-v` option to remove the created volumes.

### Suppressing Jenkins Warning using JCASC

To enhance the Gitpod experience with Jenkins, we decided to suppress a reverse proxy setup warning in Jenkins that was causing issues in the Gitpod environment.

To achieve this, we used Jenkins Configuration as Code ([JCASC](https://www.jenkins.io/projects/jcasc/)) and added the following property to the JCASC YAML file:

```yaml
jenkins:
  disabledAdministrativeMonitors:
    - "hudson.diagnosis.ReverseProxySetupMonitor"
```

For more detailed information about this configuration and the context behind it, please refer to the [corresponding issue](https://github.com/ash-sxn/GSoC-2023-docker-based-quickstart/issues/61).

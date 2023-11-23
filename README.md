# Jenkins tutorial files

Including the files for the transition from `docker` to `docker compose` for Jenkins tutorials and Jenkins installation.

## Gitpod

* Gitpod is a cloud development environment for teams to efficiently and securely develop software.
* Gitpod supports many IDEs, such as VScode, IntelliJ, and many more.

### How to set up the repo in Gitpod?

* For starting your gitpod workspace you can use `gitpod.io/#` as a prefix on any GitHub, gitlab, or bitbucket repo URL
* For our repo you can get the Gitpod workspace from [here](https://gitpod.io/#https://github.com/ash-sxn/GSoC-2023-docker-based-quickstart)
* But If you do plan to use gitpod in the future, it's recommended to install the gitpod extension which will create a launch with the gitpod button on every GitHub repo you visit.
  It can be found [here](https://chrome.google.com/webstore/detail/gitpod-online-ide/dodmmooeoklaejobgleioelladacbeki) for Chromium and [here](https://addons.mozilla.org/firefox/addon/gitpod/) for Firefox.
### Steps to run examples from the repo
* `docker compose up` is used to run examples from the project
    * There are 6 working examples in the project right now:
        * 00_old_one_from_proposal
        * 01_simple_controller_plus_agent
        * 02_custom_docker_file_connecting_agent_and_controller
        * 03_maven_tutorial
        * 04_python_tutorial
        * 05_nodejs
        * 06_multibranch_pipeline
* These examples have `README` file in it to run them manually

* To run the different examples with `docker compose up -d` add these arguments to the command:
    * `maven` - 03_maven_tutorial => `docker compose up -d maven`
    * `python` - 04_python-tutorial => `docker compose up -d python`
    * `node` - 05_nodejs => `docker compose up -d node`
    * `multi` - 06_multibranch_pipeline => `docker compose up -d multi`
* If no argument is used i.e. `docker compose up -d`, it runs the latest default example.
* The above command utilizes prebuilt images, which you might want to be cautious about as their source is not currently known or part of the Jenkins CI organization.
* So If you want to build images yourself add `-f build-docker-compose.yaml` after `docker compose`
* Eventually, the command should resemble something like this: `docker compose -f build-docker-compose.yaml up -d node` to build the Node Tutorial.

### How to Verify Jenkins Installation
* You can check the status of the container with the `docker ps` command or the `docker compose ps` one.
* You can access your running Jenkins on [http://127.0.0.1:8080](http://127.0.0.1:8080)
* On Gitpod if containers are running successfully you should see a pop-up titled `A service is available on port 8080`.
  If it doesn't come up, you can see the running service from the `PORTS` section on the right part of the terminal.

### Clean Up Instructions
* To stop and remove the running containers `docker compose down` is used.
* If you get `Resource is still in use` warning `--remove-orphans` option can be used to solve this.
* you can also add `-v` option for removing the created volumes.

### Suppressing Jenkins Warning using JCASC

In order to improve the Gitpod experience with Jenkins, we decided to suppress a reverse proxy setup warning in Jenkins.
This warning was causing issues in the Gitpod environment.

To achieve this, we made use of Jenkins Configuration as Code ([JCASC](https://www.jenkins.io/projects/jcasc/)) and added the following property to the JCASC YAML file:

We've added the following property in the JCASC YAML file:

```yaml
jenkins:
  disabledAdministrativeMonitors:
    - "hudson.diagnosis.ReverseProxySetupMonitor"
```

For more detailed information about this configuration and the context behind it, please refer to the [corresponding issue](https://github.com/ash-sxn/GSoC-2023-docker-based-quickstart/issues/61).
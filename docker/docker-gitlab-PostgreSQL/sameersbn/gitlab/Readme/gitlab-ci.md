# GITLAB CI

## Configuration

Add the CI Runner to the Docker Compose YAML file.

```yaml
gitlabsRunner:
  image: gitlab/gitlab-runner:1.3.3
  container_name: gitlab-runner
  environment:
  #1  - URL=http://10.6.64.22:10080/ci
  #2  - REGISTRATION_TOKEN=aNSfdLtyq_6DBgsh1-Me
  #3  - DESCRIPTION=gitlab_runner
  #4  - EXECUTOR=docker
  volumes:
    - /srv/docker/gitlab-runner/config:/etc/gitlab-runner
    - /var/run/docker.sock:/var/run/docker.sock
    - /etc/localtime:/etc/localtime:ro
    - /etc/timezone:/etc/timezone:ro
```

There are several notices here:

1. You must put "https://" or "http:" in the front, otherwise, the error message appear (`status=only http or https scheme supported`)

2. You must put "ci" in the url indicating that you are connecting to the CI Runner url, otherwise CI won't work.
3. [add ci to the end of URL](https://gitlab.com/gitlab-org/gitlab-ci-multi-runner/issues/1092) or [access CI](https://gitlab.com/gitlab-org/gitlab-ce/issues/13807)

3. Only sameersbn's GitLab Docker Image (v1.1.4) takes these parameters(#1, #2, #3, #4). And in the currnet `docker-compoe.yml` file, it does not have these parameters since the official `gitlab-ci-multi-runner` image is chosen.
Follow this registration process for gitLab official image.
[Run gitlab-runner in a container](https://gitlab.com/gitlab-org/gitlab-ci-multi-runner/blob/master/docs/install/docker.md)
Although docker Executer support is added in v0.3.1, Sameersbn just has one executor, i.e. shell.
[Introduce shell type](https://gitlab.com/gitlab-org/gitlab-ci-multi-runner/commit/f0ce49eee966da3e2ab31716b8f3e82cf4bdbf7c)
[Sameersbn's multi runner](https://github.com/sameersbn/docker-gitlab-ci-multi-runner)

```sh
docker exec -it gitlab-runner gitlab-runner register

# Please enter the gitlab-ci coordinator URL (e.g. https://gitlab.com/ci )
# https://gitlab.com/ci
# Please enter the gitlab-ci token for this runner
# xxx
# Please enter the gitlab-ci description for this runner
# my-runner
# INFO[0034] fcf5c619 Registering runner... succeeded
# Please enter the executor: shell, docker, docker-ssh, ssh?
# docker
# Please enter the Docker image (eg. ruby:2.1):
# ruby:2.1
# INFO[0037] Runner registered successfully. Feel free to start it, but if it's
# running already the config should be automatically reloaded!
```

Couple of things.

the `CI_SERVER_URL`, `RUNNER_TOKEN`, `RUNNER_DESCRIPTION` and `RUNNER_EXECUTOR` parameters are only applicable at the first run of the container. So if you mount a volume at /home/gitlab_ci_multi_runner/data as recommended, then changes in these parameters will have no effect on the configuration after the first run. This means that if you want to change some configuration, you will need to edit the config.toml file and restart the runner.

The `RUNNER_TOKEN` made available by GilLab is only valid for a single registration. Once a runner registers with a token, GitLab generates a new token for use with the next runner. Due to this behaviour the image does make any changes to the config.toml after the first run.

In short you need to manually edit the config.toml file and update the url.


[How can I interconnect this with gitlab in docker on the same host](https://github.com/sameersbn/docker-gitlab-ci-multi-runner/issues/4)

> It's sameersbn's version with previously mentioned environment parameters, but the official version does exactly the same thing.

- - - 

## Executors

Additionally, there are several executors for CI: [Executors](https://gitlab.com/gitlab-org/gitlab-ci-multi-runner/tree/master/docs/executors)

- Shell: Shell is the simplest executor to configure.
All required dependencies for your builds need to be installed manually on the machine that the Runner is installed.

- Docker: A better way compared with Shell. it allows to have a clean build environment,with easy dependency management (all dependencies for building the project could be put in the Docker image).The Docker executor allows you to easily create a build environment with dependent services, like MySQL.

- Docker-SSH: usually don't advise to use. It can be useful if your Docker image tries to replicate a full working system: it uses some process management system (init), exposes the SSH daemon, and contains already installed services. These kind of images are fat images.

- VirtualBox and Parallel:  It can prove useful if you want to run your builds on different Operating Systems since it allows to create virtual machines with Windows, Linux, OSX or FreeBSD and make GitLab Runner to connect to the virtual machine and run the build on it. Its usage can also be useful to reduce the cost of infrastructure

- SSH:  It's the least supported executor from all of the already mentioned ones

First of all, for a CI runner, you must write a `.gitlab-ci.yaml` file in your repo for the project configuration.
Place this file in the root of your repository and contains definitions of how your project should be built.

The YAML file defines a set of jobs with constraints stating when they should be run. Jobs are used to create builds, which are then picked up by Runners and executed within the environment of the Runner. What is important, is that each job is run independently from each other.

```
job1:
  script: "execute-script-for-job1"

job2:
  script: "execute-script-for-job2"

# a command can execute code directly (./configure;make;make install)
# or run a script (test.sh) in the repository
```


There are a few reserved keywords that cannot be used as job names:

| Keyword | Required | Description |
| ------- | -------- | ----------- |
| script | yes | Defines a shell script which is executed by Runner |
| image | no | Use docker image, covered in Use Docker |
| services | no | Use docker services, covered in Use Docker |
| stages | no | Define build stages |
| types | no | Alias for stages |
| before_script | no | Define commands that run before each job's script |
| after_script | no | Define commands that run after each job's script |
| variables | no | Define build variables |
| cache | no | Define list of files that should be cached between subsequent runs |
| only | no | Defines a list of git refs for which build is created |
| except | no | Defines a list of git refs for which build is not created |
| tags | no | Defines a list of tags which are used to select Runner |
| allow_failure | no | Allow build to fail. Failed build doesn't contribute to commit status |
| when | no	| Define when to run build. Can be on_success, on_failure or always |
| dependencies | no	| Define other builds that a build depends on so that you can pass artifacts between them |
| artifacts | no | Define list of build artifacts |
| environment | no | Defines a name of environment to which deployment is done by this build |

To better understand the function of the reserved keywords,
please look at [Keywords illustration](http://docs.gitlab.com/ce/ci/yaml/README.html#jobs)

## Multiple Runners and jobs

There are two kinds of runners in gitlab: `shared runner` and `specific runner`
- shared runner: run builds from all unassigned projects
- specific runner: run builds from all assigned projects

Some tests here to determine how the scheduler assign the jobs in a projects to the runner:

- One project with one test-job is assigned to two different runners
  After committing the repo, the scheduler will assign this build to the latest runner.
- One project with more than two test-jobs is assigned to two different runners
  After committing the repo, the scheduler will assign each build to two runners sequentially with the latest runner first, and then another runner so on so forth.

This test demonstrates that a runner will not always be occupied with projects. And there is a query for multiple runners. The scheduler will control the process and improve the efficiency.

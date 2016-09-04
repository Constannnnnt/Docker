## Gitlab-config
This is a document of the gitlab configuration.
The docker image is [sameersbn/gitlab:8.9.1](https://github.com/sameersbn/docker-gitlab)

We have two versions of GitLab images.
One is [sameersbn/gitlab: 8.9.1](https://github.com/sameersbn/docker-gitlab)
while another is the official image [gitlab/gitlab-ce](https://hub.docker.com/r/gitlab/gitlab-ce/).
However, compared with sameersbn/gitlab: 8.9.1, the official one has less environments variables in configurations.

## Docker Command

```sh
docker run --name gitlabs -d \
  --link gitlabs-postgresql:postgresql \
  --link gitlabs-redis:redisio \
  -p 10022:22 \
  -p 10080:80 \
  -e 'GITLAB_HOST=${HOST_IP}' \
  -e 'GITLAB_PORT=10080' \
  -e 'GITLAB_ROOT_PASSWORD=mypassword' \
  -e 'GITLAB_SSH_PORT=10022' \
  -e 'GITLAB_SECRETS_DB_KEY_BASE=long-and-random-alpha-numeric-string' \
  -e 'SMTP_ENABLED=true' \
  -e 'SMTP_PORT=25' \
  -e 'SMTP_HOST=mail1.astri.org' \
  -e 'SMTP_STARTTLS=false' \
  -v /etc/localtime:/etc/localtime:ro \
  -v /etc/timezone:/etc/timezone:ro \
  -v /srv/docker/gitlabs/gitlab:/home/git/data \
  sameersbn/gitlab:8.9.1
```

### SMTP setting

`SMTP_ENABLED`: true if SMTP_USER is specified.
`SMTP_PORT`: 587 is the default value. And here what we should input is 25.
`SMTP_AUTHENTICATION`: if the user if specified, the value is login by default.
                     However, in this way, you have to input the valid password.
`SMTP_DOMAIN`: you don't have to specify the domain.
`SMTP_USER`: user
`SMTP_PASS`: password

localtime and timezone volume help to sync the time of docker with the host.
However, the time of the application itself should be setup on the administration panel.

All procedures and process of gitlab management can be implemented inside the docker through the port.

If bug founded, there are three ways finding out the existing errors and its reasons.

- Check the log:

```sh
# enter the gitlab container
docker exec -it [container-id] bash

# check the log
cd /home/git/gitlab/log/production.log
```

> `sidekiq.log` can help to find the messages relevant to email etc.

- Go to the Administration panel, click the "background jobs" buttom. Then, jobs executions can be clearly seen.

- Besides, "logs" on the dashboard can also show all the logs of the application if it does not shut down.

### Notes

If you want to restart the service inside the container, use `supervisorctl reload` to restart the service. Or you can stop and restart the container.

You can modify *the gitlab settng*`docker-container:/home/git/gitlab/config/gitlab.yml`, *production setting*`docker-container: /home/git/gitlab/config/environments/production.rb` and *smtp setting*` (docker-container:/home/git/gitlab/config/initializers/smtp_setting.rb)`.

After modification, you must restart the service.

You can set the Sign in/Sign out page at the `Appearance` on the dashboard of `admin area`.

You can broadcast messages to every user at `Message` on the dashboard of `admin area`.

You can modify the setting at `Setting` on the dashboard of `admin area`.

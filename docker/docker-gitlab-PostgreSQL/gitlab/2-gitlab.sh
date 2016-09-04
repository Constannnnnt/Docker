docker run --name gitlab -d \
  --link gitlab-postgresql:postgresql \
  -p 20022:22 \
  -p 20080:80 \
  -e 'GITLAB_PORT=20080' \
  -e 'GITLAB_PORT=20022' \
  -e 'GITLAB_SECRETS_DB_KEY_BASE=long-and-random-alpha-numeric-string' \
  -v /etc/localtime:/etc/localtime:ro \
  -v /etc/timezone:/etc/timezone:ro \
  -v /srv/docker/gitlab/config:/etc/gitlab \
  -v /srv/docker/gitlab/logs:/var/log/gitlab \
  -v /srv/docker/gitlab/data:/var/opt/gitlab \
  gitlab/gitlab-ce:latest
  #-e 'GITLAB_ROOT_PASSWORD=mypassword' \
#  --link gitlab-redis:redisio \

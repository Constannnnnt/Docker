docker rm -f gitlabs
docker run --name gitlabs --rm \
  --link gitlabs-postgresql-master:postgresql \
  --link gitlabs-redis:redisio \
  -p 10022:22 \
  -p 10080:80 \
  -e 'GITLAB_HOST=10.6.64.22' \
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
  sameersbn/gitlab:8.8.5 app:rake gitlab:backup:restore

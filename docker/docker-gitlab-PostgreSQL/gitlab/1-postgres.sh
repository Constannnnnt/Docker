docker run --name gitlab-postgresql -d \
  -e 'DB_NAME=gitlabhq_production' \
  -e 'DB_USER=gitlab' \
  -e 'DB_PASS=password' \
  -e 'DB_EXTENSION=pg_trgm' \
  -v /etc/localtime:/etc/localtime:ro \
  -v /etc/timezone:/etc/timezone:ro \
  -v /srv/docker/gitlab/postgresql:/var/lib/postgresql \
  sameersbn/postgresql:9.4-22

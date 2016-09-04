docker run --name gitlabs-postgresql-master -d \
  -e 'DB_NAME=gitlabhq_production' \
  -e 'DB_USER=gitlab' \
  -e 'DB_PASS=password' \
  -e 'DB_EXTENSION=pg_trgm' \
  -e 'REPLICATION_USER=repluser' \
  -e 'REPLICATION_PASS=repluserpass' \
  -v /etc/localtime:/etc/localtime:ro \
  -v /etc/timezone:/etc/timezone:ro \
  -v /srv/docker/gitlabs/postgresql:/var/lib/postgresql \
  sameersbn/postgresql:9.4-22

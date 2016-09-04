docker run --name gitlabs-postgresql-slave01 -d \
  --link gitlabs-postgresql-master:master \
  -e 'REPLICATION_MODE=slave' \
  -e 'REPLICATION_SSLMODE=prefer' \
  -e 'REPLICATION_HOST=master' \
  -e 'REPLICATION_PORT=5432' \
  -e 'REPLICATION_USER=repluser' \
  -e 'REPLICATION_PASS=repluserpass' \
  -v /etc/localtime:/etc/localtime:ro \
  -v /etc/timezone:/etc/timezone:ro \
  -v /srv/docker/gitlabs/postgresql-slave:/var/lib/postgresql \
  sameersbn/postgresql:9.4-22

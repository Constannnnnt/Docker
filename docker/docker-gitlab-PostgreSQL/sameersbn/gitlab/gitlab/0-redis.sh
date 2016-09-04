docker run --name gitlabs-redis -d \
  -v /etc/localtime:/etc/localtime:ro \
  -v /etc/timezone:/etc/timezone:ro \
  -v /srv/docker/gitlabs/redis:/var/lib/redis \
  sameersbn/redis:latest

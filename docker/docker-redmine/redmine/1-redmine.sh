docker run -p 3000:3000 -d --name red-demo \
  --net redmine-demo \
  -v /etc/localtime:/etc/localtime:ro \
  -v /etc/timezone:/etc/timezone:ro \
  --link red-postdb:postgres \
  redmine

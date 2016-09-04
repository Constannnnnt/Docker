docker run -d --net redmine-demo \
  --name red-postdb \
  -e POSTGRES_PASSWORD=secret \
  -e POSTGRES_USER=dhtsys \  
  -v /etc/localtime:/etc/localtime:ro \
  -v /etc/timezone:/etc/timezone:ro \
  postgres:latest

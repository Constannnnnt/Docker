docker run -d --name jira-db \
  --net jira_demo \
  -p 3306:3306 \
  -e MYSQL_ROOT_PASSWORD=mypassword \
  -e MYSQL_DATABASE=mydatabase \
  -v /etc/localtime:/etc/localtime:ro \
  -v /etc/timezone:/etc/timezone:ro \
  -v /var/mariadb/data:/var/lib/mysql \
  mariadb:7.1.0

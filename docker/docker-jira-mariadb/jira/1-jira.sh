JIRA_TAG=7.1.0 
docker run -d --name "jira-container" \
  -p "8080:8080" \
  -v "`pwd`/atlassian/jira-data:/var/atlassian/jira" \
  --user="1000:1000" \
  -e "CATALINA_OPTS=" \
  --link "jira-db:jira-db" \
  -v "/etc/localtime:/etc/localtime:ro" \
  -v "/etc/timezone:/etc/timezone:ro" \
  --net jira_demo \
  cptactionhank/atlassian-jira-software:${JIRA_TAG}

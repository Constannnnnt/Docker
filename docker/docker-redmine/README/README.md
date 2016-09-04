# Redmine Configuration and Backup

## Configuration

Currently, there are two versions of redmine docker images, i.e. [official redmine](https://hub.docker.com/_/redmine/) and [sameersbn/redmine](https://github.com/sameersbn/docker-redmine). The alternative docker image, `sameersbn/redmine`, is highly recommmended, which has more environment variables and are more compatible than the official one.

For the configuration details, please look at the docker-compose.yml
The configuration is quite close to that of gitlab except that
`sameersbn/redmine` does not specify the hostname, which implys that
when the new user receives the invitation email, the link directs to
"localhost:3000" by default. You can not configure it in the yml file,
but modify it in the `setting` of `administration area`.

Also, by default, the username is `admin` with password `admin`.

## Backup

There are three ways backing up redmine, which are exactly the same
as those of backing up gitlab.

1.  Copy and paste the entire directory
2.  Docker command
3.  Rake command

###  Copy and paste

```sh
# Create backup containers, remember to specify the backup directory
docker-compose up -d

# Stop the backup containers
docker stop xxxx

# Copy all folers and paste
sudo cp -a /PATH/TO/ORIGINAL/REDMINE/. /PATH/TO/BACKUP/REDMINE

# Restart the containers
docker restart xxxx
```

### Dock command

For details, please look at the gitlab-rake-back, it is almost the same.

### Rake command

For details, please look at the gitlab-rake-back, it is almost the same.

---
It is highly recommended using Copy and Paste backup.
---
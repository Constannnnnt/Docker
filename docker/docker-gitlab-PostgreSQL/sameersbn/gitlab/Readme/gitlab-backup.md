# Copy GitLab Backup

Before backup, I have already inserting some data into the database, such as creating users, creating groups, projects, pushing files etc.

## Copy the mount volume

Assuming that you have already created some containers running gitlab, postgresql and redis etc.

First, you should specify the environment variables as well as the compose yml, and the env.sh file is attached below.

> This test was processed in `docker-gitlab-PostgreSQL/backup-env/copy-backup`

```sh
#!/bin/bash
export redis_name=redis_backup
export redis_path=/srv/docker/gitlabs_backup/redis
export postgres_name=postgres_backup
export postgres_path=/srv/docker/gitlabs_backup/postgresql
export port1=10081
export port2=10023
export gitlabs_name=gitlabs_backup
export gitlabs_path=/srv/docker/gitlabs_backup/gitlab
```

Next,

```sh
source env.sh
docker-compose up -d
```

> `-d` means detached mode, running backend detached with the shell

So that your containers are created and starting to run.

You can check the logs to see whether it finished or not.
```sh
docker logs [gitlab-container-ID]
```

When the configuration is finished, remove all newly started containers.

```sh
docker rm -f [container-IDs]*
```

Stop all original containers and Copy all folders and files in the original directory to the backup directory.

```sh
docker stop [original-gitlab-container-ID]
sudo cp -a /PATH/TO/ORIGINAL/GITLAB/. /PATH/TO/BACKUP/GITLAB
```
> e.g. sudo cp -a /srv/docker/gitlabs/. /srv/docker/gitlabs_backup/

Create and run new containers where your backup docker-compose.yml being stored.

```sh
source env.sh
docker-compose up -d
```
> `-d` detached mode, running backend detached with the shell

## Attention

In this way, an emerged problem is that the backup-containers can both read and write data, which means that if you keep running these containers for a long period, there may exist data inconsistency. The good practice is that after copying all the files, just leave it there without running new containers.

## Restore GitLab

Restoring the original Gitlab is almost the same.
Just considering the backup gitlab as the original gitlab,
copying the mount volume and restarting services.

# Rake-GitLab Backup

This test is performed after copy backup, i.e. the backup gitlab in the previous test is considered as the original gitlab in this backup test.

## Using docker command to Backup

[Gitlab-Backup](https://github.com/sameersbn/docker-gitlab)

Before taking a backup make sure the container is stopped and removed to avoid container name conflicts.

```sh
docker stop gitlab && docker rm gitlab
```

Execute the rake task to create a backup.

```sh
docker run --name gitlab -it --rm [OPTIONS] \
sameersbn/gitlab:8.9.2 app:rake gitlab:backup:create
```

> A backup will be created in the backups folder of the Data Store. You can change the location of the backups using the _GITLAB_BACKUP_DIR_ configuration parameter.

> Author's word: Backups can also be generated on a running instance using docker exec However, to avoid undesired side-effects, I advice against running backup and restore operations on a running instance.

Note: However, this is only pratical to scripts (tried and succeed). To docker-compose file, this error will appear:
```
Configuring gitlab::database
ERROR:
Please configure the database connection.
Refer http://git.io/wkYhyA for more information.
Cannot continue without a database. Aborting...
```

I have tried to specify the custom network as well as default network, use legacy link to connect the database and gitlab. But failed at last.

One of the reasons may be that you need to have a working gitLab installation before you can perform a restore. This is mainly because the system user performing the restore actions `git`, is usually not allowed to create or delete the SQL database where it needs to import data into `gitlabhq_production`. All existing data will be either erased `SQL` or moved to a separate directory `repositories, uploads`.

There may be a solution that when runing the docker command, we need to specify the environments again to connect to the database.

[rake backup&restore](https://github.com/gitlabhq/gitlabhq/blob/master/doc/raketasks/backup_restore.md)

## Shell Rake Backup & Restore

[rake backup&restore](https://github.com/gitlabhq/gitlabhq/blob/master/doc/raketasks/backup_restore.md)
The offical documents are quite detailed and it provides many methods to backup and restore. Following all steps can ensure the data consistency as well as security.

And what I have tried:

### Backup

```sh
# enter the container shell
docker exec -it [container-id] bash

# 1. use this command if you've installed GitLab with the Omnibus package
sudo gitlab-rake gitlab:backup:create

# 2. if you've installed GitLab from source
sudo -u git -H bundle exec rake gitlab:backup:create RAILS_ENV=production
```

I choose the second option, since the first one will prompt

```sh
sudo: gitlab-rake: command not found
```

After this execution, there will be tar file in mount path: e.g. /srv/docker/gitlabs/gitlab/backups/

### Restore
1. Create containers by using docker-cmpose file
2. Copy the tar file to the backup-gitlab-container's backups directory

```sh
cp backup.tar /PATH/TO/BACKUP/file
```
> e.g. cp backup.tar /srv/docker/gitlabs_backup/gitlab/backups

You can only restore a backup to exactly the same version of GitLab that you created it on, for example 8.9.1.

For details, please look at the [document](https://github.com/gitlabhq/gitlabhq/blob/master/doc/raketasks/backup_restore.md).

```
# enter the container shell
docker exec -it (container-id) bash
#Stop processes that are connected to the database
sudo service gitlab stop
bundle exec rake gitlab:backup:restore RAILS_ENV=production

#Options:
BACKUP=timestamp_of_backup (required if more than one backup exists)
force=yes (do not ask if the authorized_keys file should get regenerated)
```
However, one problem here is that you can not stop the gitlab service, since the internal services are always restarting (even if I stoped the other two containers).

But the migration can also be finished, if only `bundle exec rake gitlab:backup:restore RAILS_ENV=production` instruction is executed, and the newly created backup container can have all the data of the original one.

However, it is quite dangerous, because you are changing the database contents while the db is running, and also there may be side-effects although you can not see it right now after restoring gitlab.

Notice that the official document assumes that we install gitlab by [omnibus package](http://docs.gitlab.com/omnibus/) or [installation from source](https://gitlab.com/gitlab-org/gitlab-ce/blob/master/doc/install/installation.md).

Currently, we install docker-gitlab, which is based on omnibus package.[GitLab Docker images](http://docs.gitlab.com/omnibus/docker/README.html) and [README](https://gitlab.com/gitlab-org/gitlab-ce/tree/master/docker). The sameersbn/gitlab is also based on omnibus package.

Database encryption key is not copied. If you restore a GitLab backup without restoring the database encryption key, users who have two-factor authentication enabled will lose access to your GitLab server. Although there was no error when I tested it, it did not mean that it is a safe way.

What's more, this backup does not store your configuration files. One reason for this is that your database contains encrypted information for two-factor authentication. Storing encrypted information along with its key in the same place defeats the purpose of using encryption in the first place!

And actually, you can not find gitlab-secrets.json (for omnibus packages) or /home/git/gitlab/.secret (for installations from source).

---
To conclude, it is highly recommended to use the `copy` method
---

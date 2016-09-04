## Jira-Backup

### docker-compose

The user and group of jira container is *daemon*, which means that if we mount
the volume from the host, there will be permission error, which disables Jira
to read and write in the directory since the ownership of mounted folders and
files is *root*.

*Problem solved: In docker-compose file, we need to specify the user.
```yml
user: root
```
[Support --user option in "docker-compose up"](https://github.com/docker/compose/issues/1532)

### Copy backup

The answer is "No".
All files refresh when the containers start to run. Specifically, when new containers start running, the configuration files change and data lose while configuring the new containers.

## Jira Backup - official steps

[Backing up data](https://confluence.atlassian.com/adminjiraserver071/backing-up-data-802592964.html)

There are two stages backing up Jira according to the official documents.

1.  Backing up database contents
  - Using native database backup tools
  - Using JIRA's XML backup utility
2.  Backing up the data directory

For production use, it is strongly recommended that for regular backups,
you use native database backup tools instead of JIRA's XML backup service.

When JIRA is in use, XML backups are not guaranteed to be consistent
as the database may be updated during the backup process.

JIRA does not report any warnings or error messages when an XML backup is generated with inconsistencies and such XML backups will fail during the restore process.

Native database backup tools offer a much more consistent and reliable means of storing (and restoring) data while JIRA is active.

Caveat: if you are migrating your instance, we recommend that you create an XML backup (per the directions in this guide) where possible. In certain cases, such as very large instance sizes, this may not be possible due to the system requirements for an XML backup.


### Using native database backup tools

- Using mysqldump to backup the database
```sh
mysqldump -u root -p mydatabase > backup_file.sql
```

Then, enter the password of the database.

`Database backup successfully`.
There will be a sql file in the same directory
and all the database tables can be found in the sql file.

- restore or load the database
```sh
mysql -u root -p mydatabase < backup_file.sql
```
Then, enter the password of the database.

`Database restore failed`.
After executing these two commands, the database
did run the query because when you `CTRL+C` several times,
`ERROR 2013 (HY000) at line 992: Lost connection to MySQL server during query`
will appeaer.
However, even if these two commands execute successfully or restart the container, the whole service failed.

*************************************************************************

### Using JIRA's XML backup utility

[XML](https://confluence.atlassian.com/adminjiraserver071/backing-up-data-802592964.html)
The document shows everything clearly and detailed.

#### backup

choose `system` in `adminstration`, and then choose `backup system`, input the name (just consider it as a time-stamp). This will create a zip file.

#### restore

Copy the `zip file` in the `export` directory to the `import` folder. This operation is inside docker container.

- Already configured the system:
choose `system` in `adminstration`, and then choose `restore system`, input the zip file (a time-stamp)

- While connecting to the database:
click at `import data` when Jira asks you to generate trial license, input zip file.


### Backing up the data directory

- Backup the data directory
It is crucial that you backup your Jira application's data directory, which is a sub-directory of the JIRA application home directory. in our case, it is `docker container: /jira-data/data`.

  - you can write a small shell script, placed in /etc/cron.daily,backing up files to a directory like /var/backup/jira.
  It is best to copy an existing script in /etc/cron.daily to ensure local conventions (file locations, lockfiles, permissions).

  - just copy and place it in a directory, and remember to mark it with time-stamp or something else to restore later.

- Backup the Jira index
  The index is stored in a different sub-directory, `docker-container:<jira-home>\caches`. On large instances, we recommend that you enable 'restorable index' in the system options to create backups of the index.

- Retore the data directory
  If you created a backup of the attachments directory, you will need to restore the backup into a directory where JIRA can access it.
  The process of restoring the attachments backup depends on the way it was created. Usually, you can use the same tool to restore the backup as the one that was used to create it.

There will a chance that this error will appear:

```
Error importing data: org.xml.sax.SAXException: com.atlassian.jira.exception.
DataAccessException: org.ofbiz.core.entity.GenericTransactionException: Error occurred while starting transaction.
(Communications link failure The last packet successfully received from the server was 931,350 milliseconds ago.
The last packet sent successfully to the server was 0 milliseconds ago.) java.lang.Exception: com.atlassian.jira.exception.
DataAccessException: org.ofbiz.core.entity.GenericTransactionException: Error occurred while starting transaction.
(Communications link failure The last packet successfully received from the server was 931,350 milliseconds ago.
The last packet sent successfully to the server was 0 milliseconds ago.)
```

It is because the internet connection. Refreshing the page and restarting the service.

****************************************************************************
It is recommended to use XML's backup together with index backup.
Before backing up the system, making sure that the database is not updating.
Check the logs of the database system before backing up.
****************************************************************************

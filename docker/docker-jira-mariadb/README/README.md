## Setup MariaDB as a database container for JIRA

Update: Run `docker-compose.yml`.

Following notes are old and documented before using docker-compose.

### docker commands by using scripts
1. sh [script_two.sh] first to set a mariadb container and then [script_one.sh] to set a jira container.

2. find out the port of db container

3. when setting the database in jira, the input information should be:
- database type: MySQL
- hostname:  (host ip) or just the container-name
- port: 3306 (the port of database container)
- database name: mydatabase
- username: root
- password: mypassword (specified in the script_two.sh)

> If you use docker-compose file, you can not specify the container-name in hostname above but only host ip.

However, during these steps, since the legacy container links perform differently between default bridge network and user defined networks, you do not need to add `--links` in the docker command.
	
In the user defined networks, docker will not update the hosts for you but containers do see each other.

If you create an application container (source container) under the default bridge network, and want to connect it with a database container, you should add `--link` in the docker command to conncet these two containers. Besides, when specifying the database container, you should add alias. If the alias is different from the database container name in the hosts, these two names will be updated simultaneously. Curl could resolve both of them.

if you restart the source container, the linked containers `/etc/hosts` files will be automatically updated with the source container's new IP address.

## RMsis

RMsis is an adds-on in jira. Its default listening port is 3060 and it connects to another mariadb database to store data.


By now, mariadb container hasn't supported multiple database while mysql does.
For details, please look at the [mariadb](https://hub.docker.com/_/mariadb/), [Add mariadb](https://github.com/docker-library/official-images/pull/326), [mariadb](https://github.com/docker-library/docs/tree/master/mariadb), [multiple database](https://github.com/docker-library/mariadb/issues/15) and [mysql](https://github.com/victorhahncastell/docker-docs/tree/master/mysql)


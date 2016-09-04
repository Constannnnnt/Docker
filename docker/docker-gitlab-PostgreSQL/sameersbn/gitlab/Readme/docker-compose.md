## Compose file format

There are two versions of the Compose file format – version 1
(the legacy format, which does not support volumes or networks)
and version 2 (the most up-to-date). For more information,
see [Versioning section](https://docs.docker.com/compose/compose-file/#versioning)

## *docker-compose* version

please update docker-compose to the latest version.
As I have tried, version 1.3.1 does not support network and volumes.
According to the document, version 1.6.0+ supports those relevant features.
And the current version of docker-compose is 1.7.1

### update *docker-compose*

```sh
curl -L https://github.com/docker/compose/releases/download/1.6.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose

chmod +x /usr/local/bin/docker-compose
```

## YAML file lookup

docker-compose up/config Note: If there are more than two yml files inside the same folder:

1. One of them has the default name, i.e. docker-compose.yml, and others do not. When you execute the docker-compose command, only the docker-compose.yml will be executed.

2. All of them have the custom names, [docker-compose up] and docker-compose config will not see them and will roll back to execute the docker-compose.yml in the parent directory tree.

No reference can be found at this moment.

It seems that docker-compose command only sees the docker-compose.yml.
Other yml files can not be seen.

## Serivce Discovery

If it were to be completely optimized for use with compose v2,
the gitlab container should rely on the hostname
associated with the containers, but not their IP.

Therefore, you have to specify the database hostname and port,
as well as the redis hostname and port to link them in the same network.
Besides, you should include all environment variables of postgresql
and redis inside github environment.

```yml
  - DB_ADAPTER=postgresql          * In the environment section
  - DB_HOST=postgresql             *of gitlab, these variables
  - DB_PORT=5432                   *have to be explicitly
  - DB_USER=gitlab                 *defined, which should be
  - DB_PASS=password               *the same as those of
  - DB_NAME=gitlabhq_production    *postgresql and redis.
                                   *
  - REDIS_HOST=redis               *
  - REDIS_PORT=6379                *
```

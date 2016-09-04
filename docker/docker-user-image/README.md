## Run as User (not root) in Docker

### Introduction
For a given image, there are two ways running a container as a user. Since if we do not specify the user, the container belongs to the root, and all the processes executed in the container also belongs to the root.

``` sh
docker run --rm -it -v `pwd`:/tmp/abc -w /tmp/abc/ busybox
touch abc
exit
ls -al
```

This message will show on the terminal
```
-rw-r--r-- 1 root   root       0 Jun 15 09:10 abc
```

For security reasons, it is better to run the container as a user not root.


#### Docker Command [Implementation 1]:
```sh
docker run --rm -it --user=uid:gid -v `pwd`:/path -w /path imagename
touch yeah
exit
ls -al
```

This message will show on the terminal:
```
-rw-r--r-- 1 dhtsys dhtsys     0 Jun 15 09:35 yeah
```
docker run references
> - USER:
  -u="", --user="": Sets the username or UID used and optionally the groupname or GID for the specified command. The followings examples are all valid:
  --user=[ user | user:group | uid | uid:gid | user:gid | uid:group ]

### Dockerfile [Implementation 2]:

Assuming user is dhtsys with UID 1000 and the base image enables to create a new user

```Dockerfile
FROM ubuntu
RUN useradd -u 1000 -r dhtsys
VOLUME ["/tmp/abc"]
USER dhtsys
WORKDIR /tmp/abc
```

Attention: Inside the dockerfile, if you do not specify the `gid`, the `new user gid` may be different from current `user gid`(i.e dhtsys's gid), and it may be different from the `root gid`.

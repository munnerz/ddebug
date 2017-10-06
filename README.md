# ddebug (docker debug)

ddebug is a super simple script that helps debugging containers that are
running, but either have a read-only rootfs or missing tools required to debug.

It creates a new container that shares a network, pid and ipc namespace with
the target container, and will additionally mount the target containers root
filesystem into the debug container, and `/containerfs`.

By default, it will create an alpine based container. You can change this by
specifying an alternate image as a second positional parameter.

## Usage

First, login to the host that is running your target container, or configure
your local docker client to talk to the remote machines daemon.

You'll then want to get the ID or name of the container you intend to debug:

```bash
$ docker ps
CONTAINER ID        IMAGE                                   COMMAND                  CREATED             STATUS              PORTS                    NAMES
a55225460627        gcr.io/cloudsql-docker/gce-proxy:1.10   "/cloud_sql_proxy ..."   2 days ago          Up 2 days           0.0.0.0:3306->3306/tcp   epic_kepler
```

Now run ddebug using the containers ID (here a55225460627), or name
(epic_kepler):

```bash
$ ddebug.sh epic_kepler
```

You can optionally override the debug image used like so:

```bash
$ ddebug.sh epic_kepler debian:jessie
```

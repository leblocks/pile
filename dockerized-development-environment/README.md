## What is this?

This is an attempt to create a CLI only development environment in a container. This container have the tools that I'm
used to work with. I don't want to waste time configuring it every time I need a new environment. More than that, it is
somewhat OS independent, as long as the host system has docker engine installed.

## What is inside?

* ssh server and client - general idea is to work with this container via ssh (connect from host system), to enable
ssh daemon I've used this [docker-sytemctl-replacement](https://github.com/gdraheim/docker-systemctl-replacement).

* Configured neovim - my custom configuration that I'm used to work with.

* Docker client - holding another docker engine inside such a container is an overkill, so in this container there is
only a client which connects to a hosting system docker engine via mount: _//var/run/docker.sock:/var/run/docker.sock_.

## Example usage:
Here are example usages of this dockerfile on a windows machine with docker desktop.

Build container:
```shell
docker build ^
    --tag DEV_CONTAINER_TAG ^
    --build-arg USER=test_user ^
    --build-arg PASSWORD=test_password ^
    Dockerfile .
```

Run container:
```shell
docker run ^
    --rm ^
    --detach ^
    --name arch-dev-env ^
    --volume //var/run/docker.sock:/var/run/docker.sock ^
    --volume %HOME%/.aws:/home/someuser/.aws ^
    --volume c:/work/folder:/work ^
    --publish 9999:22 ^
    --restart always ^
    DEV_CONTAINER_TAG
```

Then, connect with ssh to the container:
```shell
ssh testuser@localhost -p 9999
```


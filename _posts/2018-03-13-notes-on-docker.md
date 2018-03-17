---
layout: post
category: [tools]
tags: [docker]
infotext: 'introduction to docker'
---
{% include JB/setup %}

<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

Docker is a platform for developers and sysadmins to develop, deploy, and run 
applications with containers. The use of Linux containers to deploy applications 
is called containerization. 

Containerization is increasingly popular because containers are:

- Flexible: Even the most complex applications can be containerized.
- Lightweight: Containers leverage and share the host kernel.
- Interchangeable: You can deploy updates and upgrades on-the-fly.
- Portable: You can build locally, deploy to the cloud, and run anywhere.
- Scalable: You can increase and automatically distribute container replicas.
- Stackable: You can stack services vertically and on-the-fly.

## Concepts

Docker Engine is a client-server application with these major components:

- A server which is a type of long-running program called a daemon process 
(the `dockerd` command).
- A REST API which specifies interfaces that programs can use to talk to 
the daemon and instruct it what to do.
- A command line interface (CLI) client (the `docker` command).

### Docker daemon

The Docker daemon (`dockerd`) listens for Docker API requests and manages 
Docker objects such as images, containers, networks, and volumes. A daemon 
can also communicate with other daemons to manage Docker services.

### Docker client

The Docker client (`docker`) is the primary way that many Docker users interact 
with Docker. When you use commands such as `docker run`, the client sends these 
commands to `dockerd`, which carries them out. The docker command uses the Docker 
API. The Docker client can communicate with more than one daemon.

### Docker registries

A Docker registry stores Docker images. When you use the `docker pull` or `docker run` 
commands, the required images are pulled from your configured registry. When you use 
the `docker push` command, your image is pushed to your configured registry.

### Docker objects

When you use Docker, you are creating and using images, containers, networks, 
volumes, plugins, and other objects. This section is a brief overview of some 
of those objects.

#### IMAGES

An image is a read-only template with instructions for creating a Docker container. 
Often, an image is based on another image, with some additional customization. 

You might create your own images or you might only use those created by others and 
published in a registry. To build your own image, you create a Dockerfile with a simple 
syntax for defining the steps needed to create the image and run it. Each instruction 
in a Dockerfile creates a layer in the image. When you change the Dockerfile and rebuild 
the image, only those layers which have changed are rebuilt. This is part of what makes 
images so lightweight, small, and fast, when compared to other virtualization 
technologies.

#### CONTAINERS

A container is a runnable instance of an image. You can create, start, stop, move, 
or delete a container using the Docker API or CLI. You can connect a container to 
one or more networks, attach storage to it, or even create a new image based on its 
current state.

#### SERVICES

Services allow you to scale containers across multiple Docker daemons, which all 
work together as a swarm with multiple managers and workers. Each member of a swarm 
is a Docker daemon, and the daemons all communicate using the Docker API. A service 
allows you to define the desired state, such as the number of replicas of the service 
that must be available at any given time. By default, the service is load-balanced 
across all worker nodes. To the consumer, the Docker service appears to be a single 
application.

## The underlying technology

Docker is written in Go and takes advantage of several features of the Linux kernel 
to deliver its functionality.

### Namespaces

Docker uses a technology called namespaces to provide the isolated workspace called 
the container. When you run a container, Docker creates a set of namespaces for that 
container.

These namespaces provide a layer of isolation. Each aspect of a container runs in a 
separate namespace and its access is limited to that namespace.

Docker Engine uses namespaces such as the following on Linux:

- The pid namespace: Process isolation (PID: Process ID).
- The net namespace: Managing network interfaces (NET: Networking).
- The ipc namespace: Managing access to IPC resources (IPC: InterProcess Communication).
- The mnt namespace: Managing filesystem mount points (MNT: Mount).
- The uts namespace: Isolating kernel and version identifiers. (UTS: Unix Timesharing System).

### Control groups

Docker Engine on Linux also relies on another technology called control groups (cgroups). 
A cgroup limits an application to a specific set of resources. Control groups allow 
Docker Engine to share available hardware resources to containers and optionally enforce 
limits and constraints. For example, you can limit the memory available to a specific 
container.

### Union file systems

Union file systems, or UnionFS, are file systems that operate by creating layers, 
making them very lightweight and fast. Docker Engine uses UnionFS to provide the 
building blocks for containers. Docker Engine can use multiple UnionFS variants, 
including AUFS, btrfs, vfs, and DeviceMapper.

### Container format

Docker Engine combines the namespaces, control groups, and UnionFS into a wrapper 
called a container format.

## Docker parameters

Docker has three kinds of parameters: string, list, and bool.

The most common used parameters are:

- Storage related
  - -g, --graph="": specify the work directory
  - -s, --storage-driver="": specify the storage driver, can be devicemapper/overlay/btrfs/aufs etc
  - --storage-opt=[]: specify the parameter of the storage driver
- Network related
  - -b, --bridge="": specify the bridge, default is `docker0`
  - --dns="": specify dns
- Registry related
  - --registry-mirror=://: specify the official registry mirror
- other
  - -D, --debug=true|false: specify the log level of the docker service, default is false
  - --selinux-enabled=true|false: enable selinux, default is true

## Docker commands

- State query
  - list local images: docker images [registry_host/repo[:tag]]
  - list containers: docker ps [args]
    - -a, --all: list all undeleted containers
    - -q, --quiet: show only the container id
    - -n=m: list the m latest used containers
  - show docker system information: docker info
  - show docker version: docker version
- Container operation
  - run command in an image: docker run [args] <image> [command]
    - -i/-t, --interactive/--tty, -it: used for foreground running container, 
    redirect the std in/out to the current terminal
    - -d: run container in background mode, return the container id
    - -v, --volume host_path:container_path: mount host path to container, can be repeated
    - --net: specify the network mode of the container, can be none/bridge/host
    - -p, --publish host_port:container_port: specify the port mapping under bridge mode, 
    can be repeated
    - -e, --env: add environment variable to the container, can be repeated
    - --rm: delete the container right after exit
    - --name: specify the name of the container
    - --dns: add dns, can be repeated
    - --privileged: allow the container modify the host, use with caution
    - --cpu-shares/--cpu-quota/--cpuset-cpus/--memory/--memory-swap: specify the 
    resources the container can use
  - show container/image information: docker inspect <image>|<container>
  - show std out of container: docker logs [args] <container>
    - -f, --follow: dynamic output
    - --since: show logs after specified time
    - -t, --timestamp: show time
  - use `SIGTERM` to terminate the container, use `SIGKILL` after timeout: docker stop [args] <container>
    - -t, --time: specify the timeout in seconds, default is 10 seconds
  -  use `SIGKILL` or specified signal to terminate the container: docker kill [args] <container>
    - -s, --signal: specify the signal, default is `KILL`
  - run command in specified container: docker exec [args] <container> <command>, docker-exec is 
  similar to docker-run, docker-run starts a new container with specified image, while docker-exec 
  run command in an existing container. For example, use `docker exec -it <container> /bin/bash` 
  to run shell in <container>
  - delete specified container: docker rm <containerID>
  - commit a container to a new image: docker commit <containerID> <image>
  - show all file system changes made in specified container: docker diff <containerID>

## Image commands

- Image operation
  - build image with specified dockerfile: docker build [args] <PATH>
    - -t, --tag, specify the name of the image, including image name and tag
    - -f, --file: specify the dockerfile, default is `./Dockerfile`
    - --no-cache: do not use cache
  - delete image (link): docker rmi <image>
  - add tag to image, duplicate the image: docker tag <image> <image>
- Image upload and publish
  - login registry: docker login <registry>
  - logout registry: docker logout <registry>
  - pull image from registry to local: docker pull <image>
  - push local image to registry: docker push <image>

## Dockerfile

{% highlight docker linenos=table %}
# specify the base image
FROM <image>

# specify the maintainer, optional
MAINTAINER <name> <<email>>

# add files to images, optional
#  ADD uncompresses the tarball, COPY does not
#  ADD supports remote files, COPY does not
# <src> and <dest> end with '/' means subdirectory
ADD <src> <dest>
COPY <src> <dest>

# run command, optional
RUN <shell_command>

# specify environment variables, optional
ENV <key> <value>

# specify the exposed ports
EXPOSE <port> [<port> ...]

# specify the entrypoint, optional
#  docker-run appends command to ENTRYPOINT, docker-run hides CMD
#  CMD can be parameter of ENTRYPOINT, for example
#    ENTRYPOINT ["ls"]
#    CMD ["-a", "-l"]
#  then the default entrypoint is /bin/sh -c "ls -a -l"
ENTRYPOINT <command>
ENTRYPOINT ["cmd", "arg1", "arg2", ...]
CMD <command>
CMD ["cmd", "arg1", "arg2", ...]
{% endhighlight %}

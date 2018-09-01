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

- The __pid__ namespace: Process isolation (PID: Process ID).
- The __net__ namespace: Managing network interfaces (NET: Networking).
- The __ipc__ namespace: Managing access to IPC resources (IPC: InterProcess Communication).
- The __mnt__ namespace: Managing filesystem mount points (MNT: Mount).
- The __uts__ namespace: Isolating kernel and version identifiers. (UTS: Unix Timesharing System).

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
  - __-g__, __--graph=""__: specify the work directory
  - __-s__, __--storage-driver=""__: specify the storage driver, can be `devicemapperoverlay`, `btrfs`, `aufs` etc
  - __--storage-opt=[]__: specify the parameter of the storage driver
- Network related
  - __-b__, __--bridge=""__: specify the bridge, default is `docker0`
  - __--dns=""__: specify dns
- Registry related
  - __--registry-mirror=://__: specify the official registry mirror
- other
  - __-D__, __--debug=`true`\|`false`__: specify the log level of the docker service, default is `false`
  - __--selinux-enabled=`true`\|`false`__: enable selinux, default is true

## Docker commands

- State query
  - list local images: __docker images [registry_host/repo[:tag]]__
  - list containers: __docker ps [args]__
    - __-a__, __--all__: list all undeleted containers
    - __-q__, __--quiet__: show only the container id
    - __-n=`m`__: list the m latest used containers
  - show docker system information: __docker info__
  - show docker version: __docker version__
- Container operation
  - run command in an image: __docker run [args] \<image\> [command]__
    - __-i__ / __-t__, __--interactive__ / __--tty__, __-it__: used for foreground running container, 
    redirect the std in/out to the current terminal
    - __-d__: run container in background mode, return the container id
    - __-v__, __--volume `host_path:container_path`__: mount host path to container, can be repeated
    - __--net__: specify the network mode of the container, can be `none`, `bridge`, `host`
    - __-p__, __--publish `host_port:container_port`__: specify the port mapping under bridge mode, 
    can be repeated
    - __-e__, __--env__: add environment variable to the container, can be repeated
    - __--rm__: delete the container right after exit
    - __--name__: specify the name of the container
    - __--dns__: add dns, can be repeated
    - __--privileged__: allow the container modify the host, use with caution
    - __--cpu-shares__ / __--cpu-quota__ / __--cpuset-cpus__ / __--memory__ / __--memory-swap__: specify the 
    resources the container can use
  - show container/image information: __docker inspect \<image\>\|\<container\>__
  - show std out of container: __docker logs [args] \<container\>__
    - __-f__, __--follow__: dynamic output
    - __--since__: show logs after specified time
    - __-t__, __--timestamp__: show time
  - use `SIGTERM` to terminate the container, use `SIGKILL` after timeout: __docker stop [args] \<container\>__
    - __-t__, __--time__: specify the timeout in seconds, default is `10 seconds`
  -  use `SIGKILL` or specified signal to terminate the container: __docker kill [args] \<container\>__
    - __-s__, __--signal__: specify the signal, default is `KILL`
  - run command in specified container: __docker exec [args] \<container\> \<command\>__, __docker-exec__ is 
  similar to __docker-run__, docker-run starts a new container with specified image, while docker-exec 
  run command in an existing container. For example, use `docker exec -it <container> /bin/bash` 
  to run shell in \<container\>
  - copy file from container to local host: __docker cp \<container\>:\<path_to_file\> \<local_path\>__
  - copy file from local host to container: __docker cp \<local_path\> \<container\>:\<path_to_file\>__
  - delete specified container: __docker rm \<container\>__
  - commit a container to a new image: __docker commit \<container\> \<image\>__
  - show all file system changes made in specified container: __docker diff \<container\>__

## Image commands

- Image operation
  - build image with specified dockerfile: __docker build [args] \<PATH\>__
    - __-t__, __--tag__: specify the name of the image, including image name and tag
    - __-f__, __--file__: specify the dockerfile, default is `./Dockerfile`
    - __--no-cache__: do not use cache
    - __--squash__: build image in one go
  - delete image (link): __docker rmi \<image\>__
  - add tag to image, duplicate the image: __docker tag \<image\> \<image\>__
  - to squash layers of image (might be supported in the future): __docker squash ???__
- Image upload and publish
  - login registry: __docker login \<registry\>__
  - logout registry: __docker logout \<registry\>__
  - pull image from registry to local: __docker pull \<image\>__
  - push local image to registry: __docker push \<image\>__

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

Usage
=====

```
$ make help
Available targets:
- clean: drop existing container and image
- build: create new image
- run: start a new test container and enter in it
- stop: stop the test container
- push: push the image to registry dockreg.vannes.iot:443

Variables:
- Docker registry:          DOCKREG=dockreg.vannes.iot:443
- Image name:               INAME=centos
- Image version:            VERSION=1.25.2
- Container name/host name: CNAME=vm-centos

Containers:
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES

Images:
REPOSITORY                    TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
dockreg:443/iotbzh/owncloud   8.1                 7734da65ad15        16 hours ago        1.249 GB
dockreg:443/iotbzh/centos     latest              fe75ec86771a        40 hours ago        205.3 MB
centos                        latest              0f73ae75014f        2 weeks ago         172.3 MB

```

Building docker image
=====================

Assemble the image using the Dockfile:
```
$ make build
```

Run test container
=======================

Start a new test container:
```
$ make test
```

Cleanup
=======

```
$ make clean
```

Push the image to registry
==========================

```
make push
```



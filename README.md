# Industrialisation-of-applications-build-in-embedded-environement

You need docker
Follows : <https://docs.docker.com/engine/installation/>

## install jenkins

```shell
git clone https://github.com/DDTLK/Industrialisation-of-applications-build-in-embedded-environement.git
```

```shell
cd docker-image-creator
make build
```

## install XDS

## install XDS-server

Load the pre-build AGL SDK docker image including xds-server:

```shell
wget -O - http://iot.bzh/download/public/XDS/docker/docker_agl_worker-xds-latest.tar.xz | docker load
```

Run the container

```shell
docker run \
--hostname="XDS-server" --name="XDS-server" \
--privileged -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
--detach=true \
-v $HOME/xds-workspace:/home/devel/xds-workspace \
-v $HOME/xds-workspace/.xdt:/xdt \
-p 8090:8000 \
-p 69:69 \
-p 2222:22 \
-p 10809:10809 \
-it docker.automotivelinux.org/agl/worker-xds:5.0;
```

## install XDS-tools

```shell
git clone https://github.com/DDTLK/Industrialisation-of-applications-build-in-embedded-environement.git
```

```shell
cd docker-image-creator
sed -i "s/jenkins/xds-tools/g" Makefile
make build
```

### install SDK TODO

must be in docker-image-creator

sudo /opt/AGL/xds/server/xds-utils/install-agl-sdks.sh --arch aarch64

### clone hello world TODO

must be in docker-image-creator

mkdir $HOME/xds-workspace
cd $HOME/xds-workspace
git clone --recursive https://github.com/iotbzh/helloworld-native-application.git



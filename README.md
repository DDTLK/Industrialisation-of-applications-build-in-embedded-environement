# Industrialisation-of-applications-build-in-embedded-environement

You need docker
Follows : <https://docs.docker.com/engine/installation/>

## install jenkins

Build jenkins container

```shell
cd docker-image-creator
make build
```

Run the container

```shell
docker run \
--hostname="jenkins" --name="jenkins" \
--privileged -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
--detach=true \
-v $HOME/workspace-agl/Industrialisation-of-applications-build-in-embedded-environement/.jenkins:/var/lib/jenkins \
-p 8080:8080 \
-p 50500:50000 \
-p 2224:22 \
-it docker.iot.bzh/iotbzh/jenkins:latest
```

```shell
docker exec jenkins sudo service jenkins start
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
-v $HOME/Industrialisation-of-applications-build-in-embedded-environement/xds-workspace/:/home/devel/xds-workspace \
-v $HOME/Industrialisation-of-applications-build-in-embedded-environement/xds-workspace/.xdt:/xdt \
-p 8000:8000 \
-p 6969:69 \
-p 2222:22 \
-p 10809:10809 \
-it docker.automotivelinux.org/agl/worker-xds:5.0
```

## install XDS-tools

```shell
cd docker-image-creator
sed -i "s/jenkins/xds-tools/g" Makefile
make build
```

```shell
docker run \
--hostname="XDS-tools" --name="XDS-tools" \
--privileged -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
--detach=true \
-p 8800:8800 \
-p 50000:50000 \
-p 69:69 \
-p 2226:22 \
-it docker.iot.bzh/iotbzh/xds-tools:latest
```

### install SDK TODO

must be in docker-image-creator

sudo /opt/AGL/xds/server/xds-utils/install-agl-sdks.sh --arch aarch64

### clone hello world TODO

must be in docker-image-creator

mkdir $HOME/xds-workspace
cd $HOME/xds-workspace
git clone --recursive <https://github.com/iotbzh/helloworld-native-application.git>
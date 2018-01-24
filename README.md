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
-v $HOME/Industrialisation-of-applications-build-in-embedded-environement/.jenkins:/var/lib/jenkins \
-p 8080:8080 \
-p 50500:50000 \
-p 2226:22 \
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
wget -O xds-docker-create-container.sh 'https://gerrit.automotivelinux.org/gerrit/gitweb?p=src/xds/xds-server.git;a=blob_plain;f=scripts/xds-docker-create-container.sh;hb=master'
bash ./xds-docker-create-container.sh
```

## install XDS-tools

```shell
cd docker-image-creator
sed -i "s/jenkins/xds-tools/g" Makefile
make build
```

## install SDK TODO


### clone hello world TODO

must be in docker-image-creator

mkdir $HOME/xds-workspace
cd $HOME/xds-workspace
git clone --recursive <https://github.com/iotbzh/helloworld-native-application.git>

inspect docker bridge:

docker network inspect bridge

### replace sdk-id

SDK_ID=$( xds-cli sdks ls | cut -d' ' -f1 | tail -n1 )

sed -i s/"#export XDS_SDK_ID=???"/"export XDS_SDK_ID=$ID"/g *.conf

source *.conf

### create pipeline

need ssh credential


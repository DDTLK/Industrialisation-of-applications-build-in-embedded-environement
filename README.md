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
cd scripts
bash ./xds-server-create-container.sh
```

## install XDS-tools

```shell
cd docker-image-creator
sed -i "s/jenkins/xds-tools/g" Makefile
make build
```

Run the container

```shell
cd scripts
bash ./xds-tools-create-container.sh
```

Start xds-agent

```shell
ssh -p 2224 slave@localhost
systemctl --user start xds-agent
```

## install SDK

In the xds-tools container

```shell
xds-cli sdks ls a
```

Choose an sdk and install

```shell
xds-cli sdks install "sdk_id"
```
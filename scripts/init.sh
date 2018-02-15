#!/bin/bash

#Jenkins creation
cd docker-image-creator || exit 1
if ! docker images | grep "docker.iot.bzh/iotbzh/jenkins"
then 
    sed -i "s/xds-tools/jenkins/g" Makefile || exit 1 ; 
    make build 
else 
    echo "image jenkins already created"
fi

#XDS-server creation
if ! (docker images | grep "docker.iot.bzh/iotbzh/xds-server")
then
    wget -O - http://iot.bzh/download/public/XDS/docker/docker_agl_worker-xds-latest.tar.xz | docker load || exit 1
    docker tag docker.automotivelinux.org/agl/worker-xds:5.0 docker.iot.bzh/iotbzh/xds-server:latest
    docker rmi docker.automotivelinux.org/agl/worker-xds:5.0
else
    echo "image XDS-server already created"
fi

#XDS-tools creation
if ! docker images | grep "docker.iot.bzh/iotbzh/xds-tools"
then 
    sed -i "s/jenkins/xds-tools/g" Makefile || exit 1 ;
    make build
else
    echo "image XDS-tools already created"
fi

#Create a docker subnetwork
if ! docker network inspect Jenkins-XDS | grep "Subnet"
then
    docker network create --driver=bridge --subnet=172.42.0.0/16 Jenkins-XDS || exit 1
else
    echo "bridge already installed"
fi

#Run jenkins container
if ! docker ps | grep jenkins
then
    cp -rf ../.jenkins $HOME/.jenkins
    docker run \
        --network=Jenkins-XDS \
        --hostname="jenkins" --name="jenkins" \
        --privileged -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
        --detach=true \
        -v $HOME/.jenkins:/var/lib/jenkins \
        -p 8080:8080 \
        -p 50500:50000 \
        -p 2226:22 \
        -it docker.iot.bzh/iotbzh/jenkins:latest || exit 1

    docker exec jenkins sudo service jenkins start || exit 1
    docker exec jenkins sudo service ssh start
    docker exec jenkins sudo chown jenkins $HOME/.jenkins/.ssh/config
else
    echo "jenkins container already started"
fi


#Run XDS-server container
if ! docker ps | grep xds-server
then
    bash ../scripts/xds-server-create-container.sh || exit 1
else
    echo "XDS-server container already started"
fi
#Run XDS-tools container
if ! docker ps | grep xds-tools
then
    bash ../scripts/xds-tools-create-container.sh || exit 1
else
    echo "XDS-tools container already started" 
fi

#stat xds-agent & list sdk & instruction to install sdk
sleep 10
echo "systemctl --user start xds-agent; sleep 5; xds-cli sdks ls -a; echo -e '-------------------\n\n\nTo install sdk Run -> xds-cli sdks install sdk_id\n\n\n-------------------' " | ssh -p 2224 jenkins@localhost

#enter in xds-tools
ssh -p 2224 jenkins@localhost




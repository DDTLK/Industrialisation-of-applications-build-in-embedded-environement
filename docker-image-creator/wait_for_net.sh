#!/bin/bash

### this script is used as entrypoint of the docker container to wait for network to be up ###

IFACE="veth0 eth0"

function wait_net() {
	for i in $IFACE; do
		[[ "$(cat /sys/class/net/$i/operstate 2>/dev/null)" == "up" ]] && return 1
	done
	return 0
}

while wait_net; do
	sleep 1
done

[[ $# > 0 ]] && exec "$@"
exec /bin/bash -l

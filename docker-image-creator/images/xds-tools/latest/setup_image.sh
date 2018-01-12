#!/bin/bash -x

### this script is called when building the docker image: it's executing in a temp container

echo "------------------------ Starting $(basename $0) -----------------------"

function debug() {
	set +x
	echo "-------------------------"
	echo "Command failed."
	echo "Running sleep for 1 day. To proceed:"
	echo "* run 'killall sleep' to continue"
	echo "* run 'killall -9 sleep' to abort the build"
	sig=0
	sleep 86400 || sig=$?
	# if killed -9, then abort
	[[ $sig == 137 ]] && exit 1 # abort
	set -x
	return 0 # continue
}
trap debug ERR # on error, run a sleep tp debug container

# get the INSTALL dir (the one where we were launched)
INSTDIR=$(cd $(dirname $0) && pwd -P)

################################## variables #################################

# source variables in conf file
. $INSTDIR/image.conf

################################## install docker endpoint #####################

# install the entrypoint script in /usr/bin
install --mode=755 $INSTDIR/wait_for_net.sh /usr/bin/

################################## install first-run service ###################
# all operations requiring runnning daemons (inc. systemd) must be run at first
# container instanciation

if [[ "$FIRSTRUN" == "yes" ]]; then
	mkdir -p /etc/systemd/system/multi-user.target.wants/
	cat <<EOF >/etc/systemd/system/multi-user.target.wants/firstrun.service
[Unit]
Description=Firstrun service
After=network.target 

[Service]
Type=oneshot
ExecStart=-/bin/bash -c /root/firstrun.sh
TimeoutSec=0
StandardInput=null
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF
fi

# helper func to install a firstrun hook
function firstrun_add() {
	script=$1
	level=${2:-50}
	name=${3:-$(basename $script)}

	mkdir -p /root/firstrun.d
	cp $script /root/firstrun.d/${level}_$name
}

################################## adjust system timezone ############################

ln -sf ../usr/share/zoneinfo/$TIMEZONE /etc/localtime

################################## run other scripts in turn ##############

for x in $INSTDIR/setup.d/*; do
	case $(basename $x) in
		[0-9][0-9]_*)
		echo "--------------------- start script $x ---------------------"
		. $x
		echo "--------------------- end of script $x ---------------------"
		;;
	*)
		;;
	esac
done

############################### cleanup ###################################

cd /
apt-get clean # clean apt caches
rm -rf /var/lib/apt/lists/*
rm -rf $INSTDIR # yes, I can auto-terminate myself !

# cleanup /tmp without removing the dir
for x in $(find /tmp -mindepth 1); do 
	rm -rf $x || true
done

echo "------------------------ $(basename $0) finished -----------------------"

#!/bin/bash -x

# fail at first error !
set -e

# redirect outputs to log
LOGFILE=/var/log/firstrun.log
exec >$LOGFILE 2>&1

echo $(date +"%Y%m%d %H:%M:%S") Starting firstrun script

# source same file with .conf extension
. ${0%.sh}.conf

# run the scripts found in /root/firstrun.d

for x in /root/firstrun.d/*; do
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

######################### cleanup #####################

# remove firstrun
rm -rf /root/firstrun.*
rm -rf /etc/systemd/system/multi-user.target.wants/firstrun.*
systemctl daemon-reload

rm -f $LOGFILE

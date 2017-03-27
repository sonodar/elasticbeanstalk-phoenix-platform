#!/bin/bash -xe

. /etc/sysconfig/phoenix

if [ -d /etc/healthd ]; then
	# Track Nginx
	/opt/elasticbeanstalk/bin/healthd-track-pidfile --proxy nginx
	/opt/elasticbeanstalk/bin/healthd-configure --appstat-log-path /var/log/nginx/healthd/application.log --appstat-uni sec --appstat-timestamp-on 'completion'

	RESTART_HEALTHD=''

	## Track application pids
	if [ -e $PIDFILE ]; then
		/opt/elasticbeanstalk/bin/healthd-track-pidfile --name phoenix --location $PIDFILE
		RESTART_HEALTHD='true'
	fi

	## restart healthd
	if [ ! -z "$RESTART_HEALTHD" ]; then
		echo "Restarging HealthD"
		/opt/elasticbeanstalk/bin/healthd-restart
	else
		echo "Not restarting HealthD since no processes to track"
		exit 1
	fi
fi

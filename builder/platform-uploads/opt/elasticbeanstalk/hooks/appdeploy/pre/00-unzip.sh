#!/bin/bash
. /etc/sysconfig/phoenix
if /opt/elasticbeanstalk/bin/download-source-bundle; then
	rm -rf $STAGING_DIR
	mkdir -p $STAGING_DIR
	unzip -o -q -d $STAGING_DIR /opt/elasticbeanstalk/deploy/appsource/source_bundle
	rm -rf $STAGING_DIR/.ebextensions
else
	echo "No application version available."
fi

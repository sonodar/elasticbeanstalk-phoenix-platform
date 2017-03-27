#!/bin/bash -xe
cd $BUILDER_DIR
. $BUILDER_DIR/CONFIG
. /etc/sysconfig/phoenix
echo "Enabling application service for Upstart"
yum install -y gettext
envsubst < $BUILDER_DIR/templates/phoenix.conf.template > /etc/init/phoenix.conf
initctl reload-configuration


#!/bin/bash -xe
. /etc/sysconfig/phoenix
mkdir -p $CONFIG_DIR
rm -f $CONFIG_DIR/envvars
$EB_DIR/bin/get-config environment | \
  /usr/bin/env ruby -e \
  "require 'json';JSON.parse(STDIN.read).each {|k,v|key=k.gsub(/\s/,'_');puts ['export ',key,'=\"',v,'\"'].join}" \
  > $CONFIG_DIR/envvars
chown $APP_USER:$APP_GROUP $CONFIG_DIR/envvars


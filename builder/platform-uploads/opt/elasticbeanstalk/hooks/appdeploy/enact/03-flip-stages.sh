#!/bin/bash -xe
. /etc/sysconfig/phoenix
rm -rf $LIVE_DIR
mv $STAGING_DIR $LIVE_DIR
mkdir -p $LIVE_DIR/running-config
chown $APP_USER:$APP_GROUP -R $LIVE_DIR
cd $LIVE_DIR
sudo -u $APP_USER mix local.hex --force
sudo -u $APP_USER mix local.rebar --force
chown $APP_USER:$APP_GROUP -R $LIVE_DIR


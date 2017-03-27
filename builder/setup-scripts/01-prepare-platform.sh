#!/bin/bash -xe
. $BUILDER_DIR/CONFIG

echo "Creating base directories for platform."
mkdir -p $BEANSTALK_DIR/deploy/appsource/
mkdir -p $STAGING_DIR $LIVE_DIR $CONFIG_DIR
mkdir -p /var/log/nginx/healthd/
chown nginx:nginx /var/log/nginx/healthd/

echo "Creating application user and group"
groupadd -g 600 $APP_GROUP
useradd -c "$APP_NAME user" -g $APP_GROUP -u 600 -s /bin/bash -d $LIVE_DIR $APP_USER
chown $APP_USER:$APP_GROUP $LIVE_DIR $CONFIG_DIR

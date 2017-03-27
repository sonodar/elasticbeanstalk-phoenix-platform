#!/bin/bash -xe

BUILDER_DIR="/tmp/builder/"

. $BUILDER_DIR/CONFIG

wait_for_cloudinit() {
  echo "Waiting for cloud init to finish bootstrapping.."
  until [ -f /var/lib/cloud/instance/boot-finished ]; do
    echo "Still bootstrapping.. sleeping. "
    sleep 3;
  done
}

install_jq() {
  ##### INSTALL JQ TO HELP IN OUR HOOKS LATER ON #####
  echo "Installing jq"
  yum install -y jq
}

sync_platform_uploads() {
  ##### COPY THE everything in platform-uploads to / ####
  echo "Setting up platform hooks"
  rsync -ar $BUILDER_DIR/platform-uploads/ /
}

run_command() {
  echo "Running script [$1]"
  chmod +x $1
  (cd $BUILDER_DIR/setup-scripts; BUILDER_DIR=$BUILDER_DIR $1 )
  if [ $? -ne "0" ]; then
    echo "Exiting. Failed to execute [$1]"
    exit 1
  fi
}

run_setup_scripts() {
  for entry in $( ls $BUILDER_DIR/setup-scripts/*.sh | sort ) ; do
    run_command $entry
  done
}

set_permissions() {
  echo "Setting permissions in /opt/elasticbeanstalk"
  find $BEANSTALK_DIR -type d -exec chmod 755 {} \; -print
  chown -R root:root $BEANSTALK_DIR
  echo "Setting permissions for shell scripts"
  find $BEANSTALK_DIR -name "*.sh" -exec chmod 755 {} \; -print
  echo "setting permissions done."
}

cleanup() {
  echo "Done all customization of packer instance. Cleaning up"
  rm -rf $BUILDER_DIR
}

echo "Running packer builder script"

wait_for_cloudinit
install_jq
sync_platform_uploads
run_setup_scripts
set_permissions
cleanup

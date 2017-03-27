#!/bin/bash
. /etc/sysconfig/phoenix
. $CONFIG_DIR/envvars

cd $STAGING_DIR

export HOME=$STAGING_DIR
mix local.hex --force
mix local.rebar --force

[ -e package.json ] && npm install
mix deps.get
mix compile
#npm run xxxxx
mix phoenix.digest
#mix ecto.migrate


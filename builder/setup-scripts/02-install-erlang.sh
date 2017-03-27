#!/bin/bash -xe
. $BUILDER_DIR/CONFIG
cd $BUILDER_DIR

echo "Downloading Erlang/OTP rpm from https://github.com"
curl -sSLO https://github.com/sonodar/erlang-rpm/releases/download/$ERLANG_VER/erlang-$ERLANG_VER-1.amzn1.x86_64.rpm

echo "Installing Erlang/OTP"
yum localinstall -y erlang-$ERLANG_VER-1.amzn1.x86_64.rpm

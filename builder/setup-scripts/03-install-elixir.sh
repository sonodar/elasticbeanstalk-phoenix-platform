#!/bin/bash -xe
cd $BUILDER_DIR
. $BUILDER_DIR/CONFIG

echo "Installing Elixir binaries"
curl -sSL https://github.com/elixir-lang/elixir/releases/download/v$ELIXIR_VER/Precompiled.zip > Precompiled.zip
mkdir -p $ELIXIR_DIR
unzip -q Precompiled.zip -d $ELIXIR_DIR
for BIN in elixirc elixir iex mix; do
  alternatives --install /usr/bin/$BIN $BIN $ELIXIR_DIR/bin/$BIN 1
done

echo "Installing hex per default user"
mix local.hex --force
sudo -u ec2-user mix local.hex --force

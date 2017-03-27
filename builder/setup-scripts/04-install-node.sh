#!/bin/bash -xe
cd $BUILDER_DIR
. $BUILDER_DIR/CONFIG

echo "Installing Node.js binaries"
curl -sSL https://nodejs.org/dist/v$NODE_VER/node-v$NODE_VER-linux-x64.tar.xz > node-v$NODE_VER-linux-x64.tar.xz
mkdir -p `dirname $NODE_DIR`
tar Jxf node-v$NODE_VER-linux-x64.tar.xz
mv node-v$NODE_VER-linux-x64 $NODE_DIR
for BIN in node npm; do
  alternatives --install /usr/bin/$BIN $BIN $NODE_DIR/bin/$BIN 1
done

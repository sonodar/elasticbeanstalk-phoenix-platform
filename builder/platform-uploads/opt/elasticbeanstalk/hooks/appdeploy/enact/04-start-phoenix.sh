#!/bin/bash -xe
echo "Stating phoenix server"
initctl start phoenix

sleep 10

if initctl status phoenix | grep -q stop ; then
  echo "Phoenix application startup failed!"
  exit 1
fi


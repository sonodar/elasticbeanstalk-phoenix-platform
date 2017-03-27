#!/bin/bash
echo "Stopping phoenix server"
initctl status phoenix | grep -q stop || initctl stop phoenix


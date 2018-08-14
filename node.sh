#!/usr/bin/env bash

MASTER_ADDRESS=${1}

yum install -y epel-release
yum install -y salt-minion

sed -i 's/#master: salt/master: "$MASTER_ADDRESS"/g' /etc/salt/minion
salt-minion start &

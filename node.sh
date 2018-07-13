#!/usr/bin/env bash

MASTER_ADDRESS=${1}

yum install -y salt-master salt-minion
yum install -y epel-release

sed -i 's/#master: salt/master: "$MASTER_ADDRESS"/g' /etc/salt/minion


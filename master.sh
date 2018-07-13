#!/usr/bin/env bash

yum install -y salt-master salt-minion
yum install -y epel-release
yum install python-paramiko -y

sed -i 's/#auto_accept: False/auto_accept: True/g' /etc/salt/master

salt-master start &
while(true)
do
    salt '*' test.ping
    sleep 5s
done

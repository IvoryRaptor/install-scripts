#!/usr/bin/env bash

systemctl disable firewalld
systemctl stop firewalld

hostnamectl --static set-hostname  master
yum install -y epel-release
yum install -y salt-master salt-minion python-paramiko

sed -i 's/#auto_accept: False/auto_accept: True/g' /etc/salt/master

salt-master start &
while(true)
do
    salt '*' test.ping
    sleep 5s
done

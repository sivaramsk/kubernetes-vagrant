#!/bin/bash

IPV4_ADDR=$(/sbin/ifconfig eth1 | awk -F ' *|:' '/inet addr/{print $4}')

echo $IPV4_ADDR
sed -i 's/Environment="KUBELET_CONFIG_ARGS[^"]*/& --node-ip='"${IPV4_ADDR}"'/' /etc/systemd/system/kubelet.service.d/10-kubeadm.conf

bash /vagrant/setup/join-command

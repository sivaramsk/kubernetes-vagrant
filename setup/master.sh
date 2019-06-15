#!/bin/bash

IPV4_ADDR=$(/sbin/ifconfig eth1 | awk -F ' *|:' '/inet addr/{print $4}')

function init_k8s {
	kubeadm init --apiserver-advertise-address="11.18.50.10" --apiserver-cert-extra-sans="11.18.50.10"  --node-name k8s-master --pod-network-cidr=192.168.0.0/16

	echo $IPV4_ADDR
	sed -i 's/Environment="KUBELET_CONFIG_ARGS[^"]*/& --node-ip='"${IPV4_ADDR}"'/' /etc/systemd/system/kubelet.service.d/10-kubeadm.conf

	# Reload systemd services
	systemctl daemon-reload

	# Restart kubelet
	systemctl restart kubelet

	# Get the connect call from join-command
	kubeadm token create --print-join-command > /vagrant/setup/join-command

}

function setup_kubeconfig {

	RET_VAL=1
	while [ $RET_VAL -ne 0 ]; do
		sleep 5
		RET_VAL=$(nc 11.18.50.10 6443 < /dev/null)
	done

     mkdir -p /home/vagrant/.kube
     cp -f /etc/kubernetes/admin.conf /home/vagrant/.kube/config
     chown vagrant:vagrant /home/vagrant/.kube/config
}

function setup_networking {
     	wget -c https://docs.projectcalico.org/v3.6/getting-started/kubernetes/installation/hosted/kubernetes-datastore/calico-networking/1.7/calico.yaml -O /home/vagrant/calico.yaml

		su vagrant -c "kubectl create -f /home/vagrant/calico.yaml"

}

function setup_kubectl {
	echo "source <(kubectl completion bash)" >> ~/.bashrc
}

function main {
	init_k8s
	setup_kubeconfig
	setup_networking
	setup_kubectl
}

main

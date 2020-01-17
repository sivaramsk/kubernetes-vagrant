#!/bin/bash

IPV4_ADDR=$(/sbin/ifconfig eth1 | awk -F ' *|:' '/inet /{print $3}')

function init_k8s {
    	
    	echo "Setting up K8S. Inside init_k8s"
    	
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

	echo "Inside setup_kubeconfig"

	RET_VAL=1
	echo "Going to wait till the kubeapi is up and running...."
	while [ $RET_VAL -ne 0 ]; do
		sleep 5
		nc -zvw120 11.18.50.10 6443
		RET_VAL=$?
		if [ $RET_VAL -ne 0 ]; then
		    echo "Unable to verify kubeapi has comeup. Quitting..."
		    exit
		fi
	done

     mkdir -p /home/vagrant/.kube
     cp -f /etc/kubernetes/admin.conf /home/vagrant/.kube/config
     chown vagrant:vagrant /home/vagrant/.kube/config
}

function setup_networking {

	echo "Inside setup_networking"

	wget -c https://docs.projectcalico.org/v2.0/getting-started/kubernetes/installation/policy-controller.yaml -O /home/vagrant/policy-controller.yaml

	su vagrant -c "kubectl create -f /home/vagrant/policy-controller.yaml"

}

function setup_kubectl {
    	echo "Inside setup_kubectl"
	echo "source <(kubectl completion bash)" >> ~/.bashrc
}

function main {
	init_k8s
	setup_kubeconfig
	setup_networking
	setup_kubectl
}

main

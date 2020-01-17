#!/bin/bash

#Configurable Variables
K8S_UBUNTU_PACKAGE_VERSION="1.17.0-00"
export DEBIAN_FRONTEND=noninteractive

function install_prereq_packages {
	apt-get -y update && \
		apt-get install -y apt-transport-https \
		ca-certificates \
		curl \
		gnupg-agent \
		software-properties-common \
		bash-completion
}


function install_docker {
	apt-get install -y docker.io

	cat > /etc/docker/daemon.json <<- EOF
	{
	   "exec-opts": ["native.cgroupdriver=systemd"]
    }
	EOF

}

function add_vagrant_user_to_docker_group {
	usermod -aG docker vagrant 
}

function disable_swap {
	swapoff -a
}

function install_k8s {
	curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

	cat > /etc/apt/sources.list.d/kubernetes.list <<- EOF
	deb http://apt.kubernetes.io/ kubernetes-xenial main
	EOF

	apt update -y 
	apt install -y kubelet=${K8S_UBUNTU_PACKAGE_VERSION} kubeadm=${K8S_UBUNTU_PACKAGE_VERSION} kubectl=${K8S_UBUNTU_PACKAGE_VERSION}
}

function main {
	install_prereq_packages
	install_docker
	add_vagrant_user_to_docker_group
	disable_swap
	install_k8s

}

main 

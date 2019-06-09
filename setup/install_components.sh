#!/bin/bash

#Configurable Variables
K8S_UBUNTU_PACKAGE_VERSION=1.14.2-00

function install_prereq_packages {
	apt-get update && apt-get -y upgrade && \
		apt-get install -y apt-transport-https \
		ca-certificates \
		curl \
		gnupg-agent \
		software-properties-common \
		bash-completion
}


function install_docker {
	sudo apt-get install -y docker.io
	sudo bash -c 'cat << EOF > /etc/docker/daemon.json
	{
	   "exec-opts": ["native.cgroupdriver=systemd"]
        }
	EOF'

}

function add_vagrant_user_to_docker_group {
	usermod -aG docker vagrant 
}

function disable_swap {
	swapoff -a
}

function install_k8s {
	curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

	sudo bash -c 'cat << EOF > /etc/apt/sources.list.d/kubernetes.list
	deb http://apt.kubernetes.io/ kubernetes-xenial main
	EOF'


	sudo apt update -y

	sudo apt install -y kubelet=${K8S_UBUNTU_PACKAGE_VERSION} kubeadm=${K8S_UBUNTU_PACKAGE_VERSION} kubectl=${K8S_UBUNTU_PACKAGE_VERSION}
}

function main {
	install_prereq_packages
	install_docker
	add_vagrant_user_to_docker_group
	disable_swap
	install_k8s

}

main 

#!/bin/bash
source versions

function install_prereq_packages {
	apt-get update && apt-get dist-upgrade && \
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
}

function disable_swap {
}

function install_k8s {
	curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
	   
	sudo bash -c 'cat << EOF > /etc/apt/sources.list.d/kubernetes.list
	deb http://apt.kubernetes.io/ kubernetes-xenial main
	EOF'
	   
	   
	sudo apt update -y
	   
	sudo apt install -y kubelet=${K8S_UBUNTU_PACKAGE_VERSION} kubeadm=${K8S_UBUNTU_PACKAGE_VERSION} kubectl=${K8S_UBUNTU_PACKAGE_VERSION}
}

function initialize_k8s_kubeadm {
}

function add_node_iP_param_to_kubeadm {
}



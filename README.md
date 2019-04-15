Kubernetes Vagrant

This is yet another Kubernetes Vagrant project. When I tried the other versions of Kubernetes-vagrant, there was a problem with their networking. The output of "kubectl get nodes -o wide" would always give the IP Address of all the nodes with the first interface in vagrant which is "10.0.2.15". I fiugred I need to pass the variable ```"--node-ip=<PRIVATE_IFC_IP>"``` to kubelet.service to get the correct IP displayed. 

To Start, simply ```vagrant up``` and you will have a single master with 3 kubernetes worker node up and running. 

Version's used
	Ubuntu : 16.04
	Docker : 18.06.1
	Kubernetes: 1.13.5


Tested only on MAC host

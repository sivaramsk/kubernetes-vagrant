IMAGE_NAME = "bento/ubuntu-18.04"
N = 2

Vagrant.configure("2") do |config|
    config.ssh.insert_key = false

    config.vm.define "k8s-master" do |master|
        master.vm.box = IMAGE_NAME
        master.vm.network "private_network", ip: "11.18.50.10"
        master.vm.hostname = "k8s-master"
        master.vm.provider "virtualbox" do |v|
      		v.memory = 2048
 			v.cpus = 2
 		end
        master.vm.provision "shell", inline: "/bin/bash /vagrant/setup/install_components.sh"
        master.vm.provision "shell", inline: "/bin/bash /vagrant/setup/master.sh"
    end

    (1..N).each do |i|
        config.vm.define "node-#{i}" do |node|
            node.vm.box = IMAGE_NAME
            node.vm.network "private_network", ip: "11.18.50.#{i + 10}"
            node.vm.hostname = "node-#{i}"
            node.vm.provider "virtualbox" do |v|
      			v.memory = 2048
 				v.cpus = 1
 			end
            node.vm.provision "shell", inline: "/bin/bash /vagrant/setup/install_components.sh"
            node.vm.provision "shell", inline: "/bin/bash /vagrant/setup/agent.sh"
        end
    end
end

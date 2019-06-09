IMAGE_NAME = "bento/ubuntu-16.04"
N = 1

Vagrant.configure("2") do |config|
    config.ssh.insert_key = false

    config.vm.provider "virtualbox" do |v|
        v.memory = 1024
        v.cpus = 2
    end

    config.vm.define "k8s-master" do |master|
        master.vm.box = IMAGE_NAME
        master.vm.network "private_network", ip: "192.168.50.10"
        master.vm.hostname = "k8s-master"
        master.vm.provision "file", source: "./setup/install_components.sh", destination: "/home/vagrant/install_components.sh"
        master.vm.provision "shell", inline: "/bin/bash /home/vagrant/install_components.sh"
    end

    (1..N).each do |i|
        config.vm.define "node-#{i}" do |node|
            node.vm.box = IMAGE_NAME
            node.vm.network "private_network", ip: "192.168.50.#{i + 10}"
            node.vm.hostname = "node-#{i}"
            node.vm.provision "file", source: "./setup/install_components.sh", destination: "/home/vagrant/install_components.sh"
            node.vm.provision "shell", inline: "/bin/bash /home/vagrant/install_components.sh"
        end
    end
end

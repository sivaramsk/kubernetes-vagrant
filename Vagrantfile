IMAGE_NAME = "bento/ubuntu-16.04"
N = 3

Vagrant.configure("2") do |config|
    config.ssh.insert_key = false

    config.vm.define "k8s-master" do |master|
        master.vm.box = IMAGE_NAME
        master.vm.network "private_network", ip: "192.168.50.10"
        master.vm.hostname = "k8s-master"
        master.vm.provision "ansible" do |ansible|
            ansible.playbook = "setup/master-playbook.yml"
        end

        master.vm.provider "virtualbox" do |v|
      		v.memory = 2048
 			v.cpus = 2
 		end
    end

    (1..N).each do |i|
        config.vm.define "node-#{i}" do |node|
            node.vm.box = IMAGE_NAME
            node.vm.network "private_network", ip: "192.168.50.#{i + 10}"
            node.vm.hostname = "node-#{i}"
            node.vm.provision "ansible" do |ansible|
                ansible.playbook = "setup/node-playbook.yml"
            end
            node.vm.provider "virtualbox" do |v|
      			v.memory = 2048
 				v.cpus = 1
 			end
        end
    end
end

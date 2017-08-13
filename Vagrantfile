$writeToHosts1 = <<SCRIPT
	sudo sh -c "echo '172.20.20.11	server2' >> /etc/hosts"
SCRIPT

$writeToHosts2 = <<SCRIPT
	sudo sh -c "echo '172.20.20.10	server2' >> /etc/hosts"
SCRIPT

Vagrant.configure(2) do |config|
	config.vm.box = "bertvv/centos72"  
	config.vm.provider "virtualbox" do |vb|
		vb.gui = true
	end

	config.vm.define "server1" do |server1|
		server1.vm.hostname = "server1"
		server1.vm.network "private_network", ip: "172.20.20.10"
		server1.vm.provision "shell", inline: $writeToHosts1
		server1.vm.provision "shell", inline: "yum install git -y && mkdir git && git clone https://github.com/paulgolub/training_DevOps.git git -b task1 && cat /git/sometextfile"
	end

	config.vm.define "server2" do |server2|
		server2.vm.hostname = "server2"
		server2.vm.network "private_network", ip: "172.20.20.11"
		server2.vm.provision "shell", inline: $writeToHosts2
	end
end
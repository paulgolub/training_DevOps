$num_of_machines = 3

$scr_httpd = <<SCRIPT
	yum install -y httpd
	systemctl enable httpd
	systemctl start httpd
	firewall-cmd --add-port=8090/tcp --permanent
	firewall-cmd --add-port=8080/tcp --permanent
	firewall-cmd --add-port=80/tcp --permanent
	firewall-cmd --reload
	cp /vagrant/mod_jk.so /etc/httpd/modules/
	cp /vagrant/httpd.conf /etc/httpd/conf/
	touch /vagrant/workers.properties
	echo "worker.list=lb" >> /vagrant/header
	for ((i=1;i<$num_of_machines;i++))
	do
		let id=i+1
		let ip=9+id
		echo worker.tomcatnode$id.port=8009 >> /vagrant/tmpworkers
		echo worker.tomcatnode$id.host=192.168.1.$ip >> /vagrant/tmpworkers
		echo worker.tomcatnode$id.type=ajp13 >> /vagrant/tmpworkers
		echo tomcatnode$i >> /vagrant/tmpbalance
	done
	echo "worker.lb.type=lb" >> /vagrant/footer1
	echo "worker.lb.balance_workers" >> /vagrant/prefooter2
	cat /vagrant/tmpbalance | tr '\n' ', ' > /vagrant/tmpbalance2
	cat /vagrant/prefooter2 /vagrant/tmpbalance2 > /vagrant/tmpfile
	cat /vagrant/tmpfile | tr '\n' ' = ' > /vagrant/footer2
	cat /vagrant/header vagrant/tmpworkers /vagrant/footer1 /vagrant/footer2> /vagrant/workers.properties
	rm /vagrant/header && rm /vagrant/footer1 && rm /vagrant/prefooter2 && rm /vagrant/footer2 && rm /vagrant/tmpworkers && rm /vagrant/tmpbalance && rm /vagrant/tmpbalance2 && rm /vagrant/tmpfile
	cp /vagrant/workers.properties /etc/httpd/conf/
	systemctl reload httpd
SCRIPT

$scr_tomcat = <<SCRIPT
	yum install java-1.7.0-openjdk.i686 java-1.7.0-openjdk-devel
	yum install -y tomcat tomcat-webapps tomcat-admin-webapps
	systemctl start tomcat
	systemctl enable tomcat
	firewall-cmd --add-port=8080/tcp --permanent
	firewall-cmd --add-port=8009/tcp --permanent
	firewall-cmd --reload
	mkdir /usr/share/tomcat/webapps/test/
SCRIPT

Vagrant.configure(2) do |config|
	config.vm.box = "jasonc/centos7-32bit"
	config.vm.box_check_update = false
	(2..$num_of_machines).each do |id|
		config.vm.define "tomcatnode#{id}" do |tomcat|
			tomcat.vm.network  "public_network", ip: "192.168.1.#{9+id}"
			tomcat.vm.hostname = "tomcatnode#{id}"  
			tomcat.vm.provider "virtualbox" do |vb|
				vb.gui = true
				vb.memory = "1024"
				vb.cpus = 1
			end
			tomcat.vm.provision "shell", inline: $scr_tomcat
			tomcat.vm.provision "shell", inline: "echo Node#{id} >> /usr/share/tomcat/webapps/test/index.html"
		end
	end
	config.vm.define "gate" do |gate|
		gate.vm.hostname = "gate" 
		gate.vm.network "private_network", ip: "192.168.1.2"
		gate.vm.network "forwarded_port", guest: 80, host: 8090
		gate.vm.provision "shell", inline: $scr_httpd
	end
end
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
	config.vm.box = "bertvv/centos72"
	config.vm.provider "virtualbox" do |vb|
		#vb.gui = true
		vb.memory = "4096"
	end
	config.vm.define "server" do |server|
		server.vm.hostname = "server"
		server.vm.network "private_network", ip: "192.168.10.10" 
		server.vm.network "forwarded_port", guest: 80, host: 8081
		server.vm.provision "shell", inline: $scr_httpd
	end
	config.vm.define "tomcat1" do |tomcat1|
		tomcat1.vm.hostname = "tomcat1"
		tomcat1.vm.network "private_network", ip: "192.168.10.21"
		tomcat1.vm.provision "shell", inline: $scr_tomcat
		tomcat1.vm.provision "shell", inline: "echo Tomcat1 >> /usr/share/tomcat/webapps/test/index.html"
	end
	config.vm.define "tomcat2" do |tomcat2|
		tomcat2.vm.hostname = "tomcat2"
		tomcat2.vm.network "private_network", ip: "192.168.10.22"
		tomcat2.vm.provision "shell", inline: $scr_tomcat
		tomcat2.vm.provision "shell", inline: "echo Tomcat2 >> /usr/share/tomcat/webapps/test/index.html"
	end
end
##########################################################
# 'HTTP Request Plugin' should be installed in Jenkins 
# User & password should be created for Tomcats
##########################################################

$scr_httpd = <<SCRIPT
	yum install -y httpd
	systemctl enable httpd
	systemctl start httpd
	#firewall-cmd --add-port=8009/tcp --permanent
	#firewall-cmd --add-port=8080/tcp --permanent
	#firewall-cmd --add-port=80/tcp --permanent
	#firewall-cmd --reload
	systemctl stop firewalld
	cp /vagrant/mod_jk.so /etc/httpd/modules/
	cp /vagrant/httpd.conf /etc/httpd/conf/
	cp /vagrant/workers.properties /etc/httpd/conf/
	systemctl reload httpd
SCRIPT

$scr_tomcat = <<SCRIPT
	systemctl stop firewalld
	yum install java-1.8.0-openjdk.i686 java-1.8.0-openjdk-devel
	yum install -y tomcat tomcat-webapps tomcat-admin-webapps
	cp /vagrant/tomcat-users.xml /usr/share/tomcat/conf/tomcat-users.xml
	systemctl start tomcat
	systemctl enable tomcat
	#firewall-cmd --add-port=8080/tcp --permanent
	#firewall-cmd --add-port=8009/tcp --permanent
	#firewall-cmd --reload
	mkdir /usr/share/tomcat/webapps/test/
SCRIPT

$scr_jnks = <<SCRIPT
	sudo yum install java-1.8.0-openjdk.i686 java-1.8.0-openjdk-devel
	sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
	sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
	sudo yum install -y jenkins
	echo "tomcat1 192.168.10.21" >> /etc/hosts
	echo "tomcat2 192.168.10.22" >> /etc/hosts
SCRIPT

$scr_nxs = <<SCRIPT
	sudo cp /vagrant/nexus-2.14.5-02-bundle.tar.gz /usr/local
	cd /usr/local
	sudo tar xvzf nexus-2.14.5-02-bundle.tar.gz
	sudo ln -s nexus-2.14.5-02 nexus
	cd /usr/local/nexus
	adduser nexus
	chown -R nexus:nexus ./bin/nexus
	#echo "RUN_AS_USER=nexus" >> ./bin/nexus
	#./bin/nexus console
	#./bin/nexus start
SCRIPT

$scr_git = <<SCRIPT
	sudo yum install git
SCRIPT

Vagrant.configure(2) do |config|
	config.vm.box = "bertvv/centos72"
	config.vm.define "server" do |server|
		server.vm.provider :virtualbox do |vb|
			vb.customize ["modifyvm", :id, "--memory", "4096"]
			vb.customize ["modifyvm", :id, "--cpus", "2"]
		end
		server.vm.hostname = "server"
		server.vm.network "private_network", ip: "192.168.10.10"
		##########################
		# 80 -> 8800 (Apache)
		# 8080 -> 8080 (Jenkins)
		# 8081 -> 8081 (Nexus)
		##########################
		server.vm.network "forwarded_port", guest: 80, host: 8800
		server.vm.network "forwarded_port", guest: 8080, host: 8080
		server.vm.network "forwarded_port", guest: 8081, host: 8082
		server.vm.provision "shell", inline: $scr_httpd
		server.vm.provision "shell", inline: $scr_jnks
		#server.vm.provision "shell", inline: $scr_git
		#server.vm.provision "shell", inline: $scr_nxs
		#adduser nexus
		#chown -R nexus:nexus ./bin/nexus
		#RUN_AS_USER="nexus"
	end
	config.vm.define "tomcat1" do |tomcat1|
		tomcat1.vm.provider :virtualbox do |vb|
			vb.customize ["modifyvm", :id, "--memory", "4096"]
			vb.customize ["modifyvm", :id, "--cpus", "1"]
		end
		tomcat1.vm.hostname = "tomcat1"
		tomcat1.vm.network "private_network", ip: "192.168.10.21"
		tomcat1.vm.network "forwarded_port", guest: 8081, host: 8081 # nexus port 8081 -> 8081
		tomcat1.vm.provision "shell", inline: $scr_tomcat
		#tomcat1.vm.provision "shell", inline: "echo Tomcat1 >> /usr/share/tomcat/webapps/test/index.html"
		tomcat1.vm.provision "shell", inline: $scr_nxs
	end
	config.vm.define "tomcat2" do |tomcat2|
		tomcat2.vm.provider :virtualbox do |vb|
			vb.customize ["modifyvm", :id, "--memory", "512"]
			vb.customize ["modifyvm", :id, "--cpus", "1"]
		end
		tomcat2.vm.hostname = "tomcat2"
		tomcat2.vm.network "private_network", ip: "192.168.10.22"
		tomcat2.vm.provision "shell", inline: $scr_tomcat
		#tomcat2.vm.provision "shell", inline: "echo Tomcat2 >> /usr/share/tomcat/webapps/test/index.html"
	end
end

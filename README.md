# training_DevOps
DevOps20170802

You need 3 virtual machines:

1. Install tomcat and create dir 'test' in '/usr/share/tomcat' on the first machine
2. Install tomcat and create dir 'test' in '/usr/share/tomcat' on the second machine
  Installation helper for tomcat:
    - JRE install: sudo yum install java-1.8.0-openjdk
    - Installation is simple: sudo yum install tomcat tomcat-webapps tomcat-admin-webapps
    - Enable: sudo systemctl enable tomcat (enable for auto start)
    - Startup: sudo systemctl start tomcat (http://localhost:8080)
    - Do not forget about firewall
3. Install Apache (httpd) on the third machine
  Installation helper for httpd:
    - sudo yum install httpd
    - Do not forget enable and start httpd on the system
    - Do not forget about firewall first
    
Or you can use Vagrant file too.

You should copy:
httpd.conf -> /etc/httpd/conf/ (rewrite the file)
mod_jk.so -> /etc/httpd/modules/
workers.properties -> /etc/httpd/conf/

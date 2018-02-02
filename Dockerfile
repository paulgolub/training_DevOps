FROM tomcat:8.0.20-jre8

ARG VERSION

RUN mkdir /usr/share/tomcat/webapps/test/
WORKDIR /usr/share/tomcat/webapps/test/
RUN curl -o test.war http://192.168.10.21:8081/nexus/content/repositories/snapshots/task3_1/$VERSION/test3.war

EXPOSE 8080

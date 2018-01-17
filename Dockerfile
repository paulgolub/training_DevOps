FROM tomcat

MAINTAINER Pavel

#ARG IP_ADDR=localhost
#arg port=8088
#ARG TREE
#ARG VERSION
#ARG ARTIFACT

RUN apt-get update && apt-get -y upgrade

WORKDIR /usr/share/tomcat/webapps/test/

#RUN curl -o test.war \"http://${IP_ADDR}:${PORT}/nexus/content/repositories/snapshots/${TREE}/${VERSION}/${ARTIFACT}

WORKDIR /usr/local/tomcat

COPY tomcat-users.xml /usr/local/tomcat/conf/tomcat-users.xml
COPY context.xml /usr/local/tomcat/webapps/manager/META-INF/context.xml

EXPOSE 8088

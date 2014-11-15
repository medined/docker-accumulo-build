FROM ubuntu:14.04
MAINTAINER David Medinets <david.medinets@gmail.com>

#
# Install Java
#

RUN apt-get update && \
  apt-get install -y software-properties-common && \
  add-apt-repository -y ppa:webupd8team/java && \
  echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections && \
  echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections && \
  apt-get update && \
  apt-get install -y oracle-java8-installer

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

#
# Install Maven
#
RUN echo "deb http://ppa.launchpad.net/natecarlson/maven3/ubuntu precise main" >> /etc/apt/sources.list && \
  echo "deb-src http://ppa.launchpad.net/natecarlson/maven3/ubuntu precise main" >> /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y --force-yes install maven3 && \
  rm -f /usr/bin/mvn && \
  ln -s /usr/share/maven3/bin/mvn /usr/bin/mvn

RUN mkdir -p /root/.m2

ADD settings.xml /root/.m2/settings.xml

#
# Clone the brooklyn project
#
RUN apt-get install -y git 
RUN git clone https://github.com/apache/accumulo.git

WORKDIR /accumulo

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

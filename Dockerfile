# Ubuntu 16.04
# Oracle Java 1.8.0_131 64 bit
# Maven 3.5.4

FROM ubuntu:16.04

MAINTAINER Alex Moore (https://github.com/torchedplatypi)

# this is a non-interactive automated build - avoid some warning messages
ENV DEBIAN_FRONTEND noninteractive

# update dpkg repositories
RUN apt-get update 

# install wget
RUN apt-get install -y wget

# get maven 3.3.9
RUN wget --no-verbose -O /tmp/apache-maven-3.5.4.tar.gz http://archive.apache.org/dist/maven/maven-3/3.5.4/binaries/apache-maven-3.5.4-bin.tar.gz

# verify checksum
RUN echo "89eea39183139e5f8a0c1601d495b3b6 /tmp/apache-maven-3.5.4.tar.gz" | md5sum -c

# install maven
RUN tar xzf /tmp/apache-maven-3.5.4.tar.gz -C /opt/
RUN ln -s /opt/apache-maven-3.5.4 /opt/maven
RUN ln -s /opt/maven/bin/mvn /usr/local/bin
RUN rm -f /tmp/apache-maven-3.5.4.tar.gz
ENV MAVEN_HOME /opt/maven

# remove download archive files
RUN apt-get clean

# set shell variables for java installation
ENV java_version 1.8.0_131
ENV filename jdk-8u131-linux-x64.tar.gz
# this is some fragile bs, who knows when oracle feels like changing this d54c1d... checksum
ENV downloadlink http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/$filename

# download java, accepting the license agreement
RUN wget -c --header "Cookie: oraclelicense=accept-securebackup-cookie" -O /tmp/$filename $downloadlink

# unpack java
RUN mkdir /opt/java-oracle && tar -zxf /tmp/$filename -C /opt/java-oracle/
ENV JAVA_HOME /opt/java-oracle/jdk$java_version
ENV PATH $JAVA_HOME/bin:$PATH

# configure symbolic links for the java and javac executables
RUN update-alternatives --install /usr/bin/java java $JAVA_HOME/bin/java 20000 && update-alternatives --install /usr/bin/javac javac $JAVA_HOME/bin/javac 20000

CMD [""]



FROM centos:7

MAINTAINER kevensen@redhat.com
ARG version=latest

RUN yum install -y http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    yum install -y ansible wget tar && \
    yum clean all && \
    rm -rf /var/cache/yum/*

ADD http://releases.ansible.com/ansible-tower/setup/ansible-tower-setup-$version.tar.gz /opt/ansible-tower-setup-$version.tar.gz
ADD inventory /opt/inventory

RUN pushd /opt/ && \
          tar -xvf /opt/ansible-tower-setup-$version.tar.gz && \
          cd ansible-tower-setup-* && \
          mv ../inventory .

          
  

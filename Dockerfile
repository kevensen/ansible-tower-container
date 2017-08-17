FROM centos:7

MAINTAINER kevensen@redhat.com
ARG version=latest

RUN yum install -y http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    yum install -y ansible wget tar && \
    yum clean all && \
    rm -rf /var/cache/yum/*

ADD http://releases.ansible.com/ansible-tower/setup/ansible-tower-setup-$version.tar.gz /opt/ansible-tower-setup-$version.tar.gz

RUN pushd /opt/ && \
          tar -xvf /opt/ansible-tower-setup-$version.tar.gz && \
          cd ansible-tower-setup-* && \
	  echo '[tower]\n \
localhost ansible_connection=local\n \
\n \
[database]\n \
\n \
[all:vars]\n \
admin_password=\'password\'\n \
\n\
pg_host=\'${DATABASE_SERVICE_NAME}\'\n \
pg_port=\'5432\'\n \
\n\
pg_database=\'${POSTGRESQL_DATABASE}\'\n \
pg_username=\'${POSTGRESQL_USERNAME}\'\n \
pg_password=\'${POSTGRESQL_PASSWORD}\'\n \
\n \
rabbitmq_port=5672\n \
rabbitmq_vhost=tower\n \
rabbitmq_username=tower\n \
rabbitmq_password=\'password\'\n \
rabbitmq_cookie=rabbitmqcookie\n \
\n \
# Needs to be true for fqdns and ip addresses\n \
rabbitmq_use_long_name=false\n \
# Needs to remain false if you are using localhost\n' > inventory && \
	./setup.sh

ENTRYPOINT ["/usr/bin/ansible-tower-service", "start"]          
  

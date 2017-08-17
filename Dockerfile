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
	  cat > inventory << EOF
[tower]
localhost ansible_connection=local

[database]

[all:vars]
admin_password='password'

pg_host='${DATABASE_SERVICE_NAME}'
pg_port='5432'

pg_database='${POSTGRESQL_DATABASE}'
pg_username='${POSTGRESQL_USERNAME}'
pg_password='${POSTGRESQL_PASSWORD}'

rabbitmq_port=5672
rabbitmq_vhost=tower
rabbitmq_username=tower
rabbitmq_password='password'
rabbitmq_cookie=rabbitmqcookie

# Needs to be true for fqdns and ip addresses
rabbitmq_use_long_name=false
# Needs to remain false if you are using localhost
EOF

          
  

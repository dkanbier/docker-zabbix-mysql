FROM centos:centos6
MAINTAINER Dennis Kanbier <dennis@kanbier.net>

# Update base images.
RUN yum distribution-synchronization -y
RUN yum makecache

# Install MySQL software 
RUN yum -y -q install mysql mysql-server 

# Cleanup
RUN yum clean all

# MySQL Config
ADD ./mysql/my.cnf /etc/mysql/conf.d/my.cnf
ADD ./zabbix/create/data.sql /tmp/create/data.sql
ADD ./zabbix/create/images.sql /tmp/create/images.sql
ADD ./zabbix/create/schema.sql /tmp/create/schema.sql

# https://github.com/dotcloud/docker/issues/1240#issuecomment-21807183
RUN echo "NETWORKING=yes" > /etc/sysconfig/network

# Custom script to setup Zabbix schema and start mysqld_safe
ADD ./scripts/start.sh /start.sh
RUN chmod 755 /start.sh

# Expose MySQL default port  
EXPOSE 3306 

# Use a volume for MySQL data
VOLUME ["/var/lib/mysql"]

# Sart the custom start script
CMD ["/bin/bash", "/start.sh"]

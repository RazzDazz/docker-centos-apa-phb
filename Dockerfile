FROM centos:8.1.1911
MAINTAINER RazzDazz

ENV REFRESHED_AT 2020-03-01

EXPOSE 80

# update os and install apache httpd and php modules and clean up
# update and upgrade throwing warnings, temporarily disabled
# RUN yum update -yq && \
#     yum upgrade -yq && \
#     yum install -yq httpd php php-mysqlnd php-snmp php-xml && \
#     yum clean all

# update os and install apache httpd and php modules and clean up
RUN yum install -yq httpd \
                    php \
                    php-mysqlnd \
                    php-snmp \
                    php-xml && \
    yum clean all

# create index.html file and index.php file
RUN echo "<!DOCTYPE html><html><body><h1>Welcome</h1></body></html>" > /var/www/html/index.html && \
    echo "<?php phpinfo(); ?>" > /var/www/html/index.php

# adjust config file /etc/httpd/conf/httpd.conf and config file /etc/php-fpm.d/www.conf
RUN sed -i "s/#ServerName www.example.com:80/ServerName localhost:80/g" /etc/httpd/conf/httpd.conf && \
    sed -i "s/;listen.owner = nobody/listen.owner = apache/g" /etc/php-fpm.d/www.conf && \
    sed -i "s/;listen.group = nobody/listen.group = apache/g" /etc/php-fpm.d/www.conf && \
    sed -i "s/listen.acl_users = apache,nginx/;listen.acl_users = apache,nginx/g" /etc/php-fpm.d/www.conf

# create socket directory defined in /etc/php-fpm.d/www.conf
RUN mkdir -p /run/php-fpm

# Copy helper scripts into container
COPY startup.sh /tmp/startup.sh
RUN chmod 777 /tmp/startup.sh

# Publishing directories
VOLUME /var/log/httpd/
VOLUME /var/log/php-fpm

# Start httpd and php-fpm using supervisor
CMD ["/tmp/startup.sh"] 

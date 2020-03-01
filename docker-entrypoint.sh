#!/bin/sh

# Print php Version
/usr/bin/php -v
# start php-fpm
echo "Starting php-fpm..."
/usr/sbin/php-fpm -daemonize

# Print apache httpd Version
/usr/sbin/httpd -v
# start apache httpd
echo "Starting apache httpd..."
/usr/sbin/httpd -DFOREGROUND

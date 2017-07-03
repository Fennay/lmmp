#!/bin/bash

/webser/php7/sbin/php-fpm
/webser/nginx/sbin/nginx
/webser/mysql5.7/support-files/mysql.server start 

exec /usr/sbin/sshd -D
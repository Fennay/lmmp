#!/bin/bash

/webser/php7/sbin/php-fpm
/webser/nginx/sbin/nginx
/webser/redis/bin/redis-server /webser/redis/conf/redis.conf
# /webser/mysql5.7/support-files/mysql.server start 

exec /usr/sbin/sshd -D
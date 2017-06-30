#!/bin/bash

/webser/php7/sbin/php-fpm
/webser/nginx/sbin/nginx

exec /usr/sbin/sshd -D

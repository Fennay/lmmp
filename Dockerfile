FROM centos:7
ENV container docker

### 安装基础库
RUN yum -y install gcc gcc-c++ \
	&& yum -y install automake autoconf libtool make \
	&& yum -y install pcre-devel zlib zlib-devel \
	&& yum -y install wget vim \
	&& yum -y install zlib zlib-devel \
	&& yum -y install libxml2 libxml2-devel openssl openssl-devel curl-devel libjpeg-devel libpng-devel freetype-devel libmcrypt-devel \
	&& yum -y install openssh-server

### 生成key
RUN ssh-keygen -A

### 创建用户组
RUN groupadd -r www \
	&& useradd -s /sbin/nologin -g www -r www 
	
### 创建目录
RUN mkdir -p /webser/{www,logs,src,redis} \ 
	&& chown -R www.www /webser/{www,logs}

### 创建pid文件
RUN touch /var/run/nginx.pid

### copy文件进来
ADD soft/nginx-1.10.1.tar.gz /webser/src/
ADD soft/php-7.1.6.tar.gz /webser/src/
ADD soft/composer.phar /webser/src/
ADD soft/redis-4.0.8.tar.gz /webser/src/

### 安装nginx
RUN cd /webser/src/nginx-1.10.1 \
	&& ./configure --prefix=/webser/nginx --with-http_ssl_module \
	&& make && make install \
	&& /webser/nginx/sbin/nginx

### 安装redis
COPY soft/redis /webser/redis
run chmod +x /webser/redis/bin/* \
	&& mkdir -p /webser/redis/rdb

### 安装php
RUN cd /webser/src/php-7.1.6 \
#	&& wget http://cn2.php.net/distributions/php-7.1.6.tar.gz \
#	&& tar zxvf php-7.1.6.tar.gz \
#	&& cd php-7.1.6 \
	&& ./configure --prefix=/webser/php7 \
		--with-config-file-path=/webser/php7/etc \
		--enable-mysqlnd \
		--with-mysqli \
		--with-pdo-mysql \
		--enable-fpm \
		--with-gd \
		--with-iconv \
		--with-zlib \
		--enable-xml \
		--enable-shmop \
		--enable-sysvsem \
		--enable-inline-optimization \
		--enable-mbregex \
		--enable-mbstring \
		--enable-ftp \
		--enable-gd-native-ttf \
		--with-openssl \
		--enable-pcntl \
		--enable-sockets \
		--with-xmlrpc \
		--enable-zip \
		--enable-soap \
		--without-pear \
		--with-gettext \
		--enable-session \
		--with-curl \
		--with-jpeg-dir \
		--with-freetype-dir \
	&& make && make install \
	&& cd /webser/php7/etc \
	&& cp ./php-fpm.conf.default php-fpm.conf \
	&& cp ./php-fpm.d/www.conf.default ./php-fpm.d/www.conf \
	&& /webser/php7/sbin/php-fpm

### 添加到环境变量
#RUN cd /etc \
#	&& echo "export PATH=$PATH:/webser/php7/bin" >> /etc/profile \
#	&& source /etc/profile
ENV PATH $PATH:/webser/php7/bin

### 复制扩展
COPY ext/* /webser/php7/lib/php/extensions/no-debug-non-zts-20160303/

### 复制配置文件
COPY config/www.conf /webser/php7/etc/php-fpm.d/www.conf

### 全局安装composer
COPY soft/composer.phar /webser/src/
RUN cd /webser/src/ \
	&& mv composer.phar /usr/local/bin/composer \
	&& chmod +x /usr/local/bin/composer \
	&& composer self-update \
	&& composer config -g repo.packagist composer https://packagist.phpcomposer.com

### 自行下载
# RUN /webser/php7/bin/php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
#	&& /webser/php7/bin/php composer-setup.php \
#	&& mv composer.phar /usr/local/bin/composer \
#	&& /webser/php7/bin/php -r "unlink('composer-setup.php');" \
	

### 执行初始化脚本
ADD run.sh /run.sh
### 增加可执行权限
RUN chmod +x run.sh
CMD ["sh","/run.sh"]
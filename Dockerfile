FROM centos:7
ENV container docker

### 安装基础库
RUN mkdir -p /webser/src \
	&& yum -y install gcc gcc-c++ \
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

### 安装nginx
RUN	cd /webser/src \
	&& wget http://nginx.org/download/nginx-1.10.1.tar.gz \
	&& tar zxvf nginx-1.10.1.tar.gz \
	&& cd nginx-1.10.1 \
	&& ./configure --prefix=/webser/nginx \
	&& make && make install \
	&& /webser/nginx/sbin/nginx

### 安装php
RUN cd /webser/src \
	&& wget http://cn2.php.net/distributions/php-7.1.6.tar.gz \
	&& tar zxvf php-7.1.6.tar.gz \
	&& cd php-7.1.6 \
	&& ./configure --prefix=/webser/php7 \
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

### 执行初始化脚本
ADD run.sh /run.sh
CMD ["sh","./run.sh"]
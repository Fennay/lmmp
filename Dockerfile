FROM centos:7
ENV container docker
RUN mkdir -p /webser/src \
	&& cd /webser/src \
	&& yum -y install gcc gcc-c++ \
	&& yum -y install automake autoconf libtool make \
	&& yum -y install pcre-devel zlib zlib-devel \\
	&& yum -y install wget \
	&& wget http://nginx.org/download/nginx-1.10.1.tar.gz \
	&& cd /webser/src \
	&& tar zxvf nginx-1.10.1.tar.gz \
	&& cd nginx-1.10.1 \
	&& yum -y install zlib zlib-devel \
	&& ./configure --prefix=/webser/nginx \
	&& make && make install \
	&& /webser/nginx/sbin/nginx \
	&& groupadd -r www \
	&& useradd -s /sbin/nologin -g www -r www \
	&& yum -y install libxml2 libxml2-devel openssl openssl-devel curl-devel libjpeg-devel libpng-devel freetype-devel libmcrypt-devel \
	&& wget http://cn2.php.net/distributions/php-7.0.10.tar.gz \
	&& tar zxvf php-7.0.10.tar.gz \
	&& cd php-7.0.10 \
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

FROM centos:7
ENV container docker
RUN yum -y install openssh-server
RUN ssh-keygen -A
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
	&& /webser/php7/sbin/php-fpm \
	&& groupadd mysql \
	&& useradd -r -g mysql mysql \
	&& yum -y install cmake ncurses-devel \
	&& cd /webser/src \
	&& wget http://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.14.tar.gz \
	&& wget https://www.fennay.com/boost_1_59_0.tar.gz/ \
	&& tar zxvf mysql-5.7.14.tar.gz \
	&& cd mysql-5.7.14 \
	&& cmake \
		-DCMAKE_INSTALL_PREFIX=/webser/mysql5.7  \
		-DMYSQL_DATADIR=/webser/data/mysql/data  \
		-DSYSCONFDIR=/etc \
		-DMYSQL_USER=mysql \
		-DWITH_MYISAM_STORAGE_ENGINE=1 \
		-DWITH_INNOBASE_STORAGE_ENGINE=1 \
		-DWITH_ARCHIVE_STORAGE_ENGINE=1 \
		-DWITH_MEMORY_STORAGE_ENGINE=1 \
		-DWITH_READLINE=1 \
		-DMYSQL_UNIX_ADDR=/var/run/mysql/mysql.sock \
		-DMYSQL_TCP_PORT=3306 \
		-DENABLED_LOCAL_INFILE=1 \
		-DENABLE_DOWNLOADS=1 \
		-DWITH_PARTITION_STORAGE_ENGINE=1  \
		-DEXTRA_CHARSETS=all \
		-DDEFAULT_CHARSET=utf8 \
		-DDEFAULT_COLLATION=utf8_general_ci \
		-DWITH_DEBUG=0 \
		-DMYSQL_MAINTAINER_MODE=0 \
		-DWITH_SSL:STRING=bundled \
		-DWITH_ZLIB:STRING=bundled \
		-DWITH_BOOST=/usr/local/boost \
	&& /webser/mysql5.7/support-files/mysql.server start
	
ADD run.sh /webser/run.sh 
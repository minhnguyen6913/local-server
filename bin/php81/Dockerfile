FROM php:8.1.29-apache-bullseye

# Surpresses debconf complaints of trying to install apt packages interactively
# https://github.com/moby/moby/issues/4032#issuecomment-192327844

ARG DEBIAN_FRONTEND=noninteractive
ARG PLATFORM

RUN if [ "$PLATFORM" = "linux/arm64" ]; then \
    curl -o ioncube.tar.gz http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_aarch64.tar.gz ; \
    else \
    curl -o ioncube.tar.gz http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz; \
    fi
RUN  tar -xvvzf ioncube.tar.gz \
    && mv ioncube/ioncube_loader_lin_8.1.so `php-config --extension-dir` \
    && rm -Rf ioncube.tar.gz ioncube \
    && docker-php-ext-enable ioncube_loader_lin_8.1
# Update
RUN apt-get -y update --fix-missing && \
    apt-get upgrade -y && \
    apt-get --no-install-recommends install -y apt-utils && \
    rm -rf /var/lib/apt/lists/*


#LIBRE OFFICE
RUN apt-get update && \
    apt-get install -y wget \
    fontconfig && \
    wget http://ftp.br.debian.org/debian/pool/contrib/m/msttcorefonts/ttf-mscorefonts-installer_3.8.1_all.deb && \
    apt --fix-broken install -y ./ttf-mscorefonts-installer_3.8.1_all.deb && \
    fc-cache -f -v

RUN apt update && apt install libreoffice -y


# Install useful tools and install important libaries
RUN apt-get -y update && \
    apt-get -y --no-install-recommends install nano wget \
dialog \
libsqlite3-dev \
libsqlite3-0 && \
    apt-get -y --no-install-recommends install default-mysql-client \
zlib1g-dev \
libzip-dev \
libicu-dev && \
    apt-get -y --no-install-recommends install --fix-missing apt-utils \
build-essential \
git \
curl \
libonig-dev && \
    apt-get install -y iputils-ping && \
    apt-get -y --no-install-recommends install --fix-missing libcurl4 \
libcurl4-openssl-dev \
zip \
openssl && \
    rm -rf /var/lib/apt/lists/* && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install xdebug
RUN pecl install xdebug-3.1.4 && \
    docker-php-ext-enable xdebug && \
    mkdir /var/log/xdebug

# Install redis
RUN pecl install redis-5.3.3 && \
    docker-php-ext-enable redis

# Install imagick
RUN apt-get update && \
    apt-get -y --no-install-recommends install --fix-missing libmagickwand-dev && \
    rm -rf /var/lib/apt/lists/*

# Workarround until imagick is available in pecl with php8 support
# Imagick Commit to install
# https://github.com/Imagick/imagick
ARG IMAGICK_COMMIT="661405abe21d12003207bc8eb0963fafc2c02ee4"

RUN cd /usr/local/src && \
    git clone https://github.com/Imagick/imagick && \
    cd imagick && \
    git checkout ${IMAGICK_COMMIT} && \
    phpize && \
    ./configure && \
    make && \
    make install && \
    cd .. && \
    rm -rf imagick && \
    docker-php-ext-enable imagick

# Other PHP8 Extensions
#install library docker not support : https://github.com/mlocati/docker-php-extension-installer

RUN curl -sSLf \
    -o /usr/local/bin/install-php-extensions \
    https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions && \
    chmod +x /usr/local/bin/install-php-extensions
RUN    install-php-extensions soap
RUN    install-php-extensions pdo_pgsql
RUN    install-php-extensions tokenizer
RUN    install-php-extensions intl
RUN    install-php-extensions pgsql
#bzip2
RUN apt-get update && apt-get install -y libbz2-dev
RUN docker-php-ext-install bz2 && docker-php-ext-enable bz2

RUN docker-php-ext-install pdo_mysql && docker-php-ext-enable pdo_mysql && \
    docker-php-ext-install pdo_sqlite && docker-php-ext-enable pdo_sqlite && \
    docker-php-ext-install bcmath && docker-php-ext-enable bcmath

RUN    docker-php-ext-install mysqli && docker-php-ext-enable mysqli
RUN    docker-php-ext-install curl && docker-php-ext-enable curl

RUN docker-php-ext-install zip && docker-php-ext-enable zip

RUN    docker-php-ext-install -j$(nproc) intl && docker-php-ext-enable intl

RUN    docker-php-ext-install mbstring && docker-php-ext-enable mbstring
RUN    docker-php-ext-install gettext && docker-php-ext-enable gettext
RUN    docker-php-ext-install fileinfo && docker-php-ext-enable fileinfo
# RUN    docker-php-ext-install pdo_pgsql && docker-php-ext-enable pdo_pgsql

RUN docker-php-ext-install calendar  && docker-php-ext-enable calendar
#RUN  docker-php-ext-install tokenizer && docker-php-ext-enable tokenizer
RUN docker-php-ext-install fileinfo  && docker-php-ext-enable fileinfo
RUN   docker-php-ext-install filter  && docker-php-ext-enable filter


RUN  docker-php-ext-install iconv  && docker-php-ext-enable iconv


RUN docker-php-ext-install pcntl  && docker-php-ext-enable pcntl


RUN docker-php-ext-install sockets  && docker-php-ext-enable sockets

RUN docker-php-ext-install zip  && docker-php-ext-enable zip
RUN docker-php-ext-install exif  && docker-php-ext-enable exif
RUN docker-php-ext-install session  && docker-php-ext-enable session

# Install Freetype
RUN apt-get -y update && \
    apt-get --no-install-recommends install -y libfreetype6-dev \
libjpeg62-turbo-dev \
libpng-dev && \
    rm -rf /var/lib/apt/lists/* && \
    docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg && \
    docker-php-ext-install gd

# Insure an SSL directory exists
RUN mkdir -p /etc/apache2/ssl

# Enable SSL support
RUN a2enmod ssl && a2enmod rewrite

# Enable apache modules
RUN a2enmod rewrite headers


RUN apt-get update && apt-get install -y net-tools

RUN  apt update && apt upgrade -y
ADD doc2pdf.sh /selinux/

RUN apt-get install -y  xfonts-utils

# Cleanup
RUN rm -rf /usr/src/*
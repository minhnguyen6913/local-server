FROM php:8.0.30-apache-bullseye

# Surpresses debconf complaints of trying to install apt packages interactively
# https://github.com/moby/moby/issues/4032#issuecomment-192327844

ARG DEBIAN_FRONTEND=noninteractive

# Update
RUN apt-get -y update --fix-missing && \
    apt-get upgrade -y && \
    apt-get --no-install-recommends install -y apt-utils && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y net-tools

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
ARG IMAGICK_COMMIT="132a11fd26675db9eb9f0e9a3e2887c161875206"

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
RUN  docker-php-ext-install tokenizer && docker-php-ext-enable tokenizer
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

# Cleanup
RUN rm -rf /usr/src/*

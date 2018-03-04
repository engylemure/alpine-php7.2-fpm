FROM php:7.2.1-fpm-alpine

MAINTAINER Jordão Rosario <jordao.rosario01@gmail.com>

RUN apk add --update \
        libxml2-dev \
        openssl-dev \
        freetype freetype-dev \
        libjpeg-turbo libjpeg-turbo-dev \
        libpng libpng-dev \
        libmcrypt-dev \
        curl-dev \
        icu-dev \
        bash \
        git \
        ca-certificates \
        nodejs \
        nano

RUN docker-php-ext-configure gd \
        --with-gd \
        --with-freetype-dir=/usr/include/ \
        --with-png-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ && \
    NPROC=$(getconf _NPROCESSORS_ONLN) && \
    docker-php-ext-install -j${NPROC} gd && \
    apk del --no-cache freetype-dev libpng-dev libjpeg-turbo-dev

RUN docker-php-ext-install \
        json xml pdo phar  \
        curl dom intl ctype \
        pdo_mysql mysqli \
        opcache iconv \
        session mbstring zip && \
    pecl channel-update pecl.php.net && \
    pecl install redis-3.1.2 && \
    pecl install memcached-3.0.3 && \
    curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/bin/composer

RUN apk add --update --virtual \
        build-dependencies \
        build-base \
        autoconf libtool

RUN apk add --update \
        libmcrypt-dev \
        mysql-client \
        imagemagick-dev

RUN pecl install imagick

RUN docker-php-ext-enable imagick


ARG PHP_VERSION=7.2
ARG ALPINE_VERSION=3.7

FROM php:${PHP_VERSION}-fpm-alpine${ALPINE_VERSION}

MAINTAINER Ala Eddine Khefifi <alakhefifi@gmail.com>

RUN apk update --no-cache
RUN apk add --no-cache \
    git \
    curl \
    wget \
    vim \
    zsh \
    libpng-dev \
    shadow \
    sudo

ARG APCU_VERSION=5.1.11
RUN set -xe \
    && apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
        icu-dev \
        zlib-dev \
    && docker-php-ext-install -j$(nproc) \
        intl \
        mysqli \
        pdo \
        pdo_mysql \
        zip \
        bcmath \
        gd \
    && pecl install \
        apcu-${APCU_VERSION} \
    && pecl clear-cache \
    && docker-php-ext-enable --ini-name 20-apcu.ini apcu \
    && docker-php-ext-enable --ini-name 05-opcache.ini opcache \
    && docker-php-ext-enable mysqli \
    && docker-php-ext-enable bcmath \
    && docker-php-ext-enable gd \
    && runDeps="$( \
        scanelf --needed --nobanner --format '%n#p' --recursive /usr/local/lib/php/extensions \
            | tr ',' '\n' \
            | sort -u \
            | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
    )" \
    && apk add --no-cache --virtual .api-phpexts-rundeps $runDeps \
    && apk del .build-deps

# php.ini
COPY php.ini /usr/local/etc/php/php.ini
COPY php.ini /usr/local/etc/php/conf.d/php.ini

# composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
ENV COMPOSER_ALLOW_SUPERUSER=1
RUN composer global require "hirak/prestissimo:^0.3" --prefer-dist --no-progress --no-suggest --classmap-authoritative \
    && composer clear-cache
ENV PATH="${PATH}:/root/.composer/vendor/bin"

# Zsh
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
RUN sed -i "s/plugins=(/plugins=(github history symfony2 docker docker-compose /g" ~/.zshrc

RUN usermod -u 1000 www-data

CMD ["php-fpm"]

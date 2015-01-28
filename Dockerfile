FROM php:latest

MAINTAINER stuart nixon <dotcomstu@gmail.com>
ENV DEBIAN_FRONTEND noninteractive


# php module build deps
RUN \
  apt-get update \
  && apt-get install -y libcurl4-gnutls-dev libxml2-dev libbz2-dev re2c libpng++-dev \
                      libpng3 libjpeg-dev libvpx-dev zlib1g-dev libgd-dev libssl-dev \
                      libtidy-dev libxslt1-dev libmagic-dev libexif-dev file libssh2-1-dev git curl wget


# php-module: curl dom bz2 gd json mysqli pcntl pdo pdo_mysql phar posix
RUN \
    /usr/local/bin/docker-php-ext-install curl dom bz2 gd json mysqli pcntl pdo pdo_mysql phar posix && \
    /usr/local/bin/docker-php-ext-install simplexml soap tidy tokenizer xml xmlreader xmlrpc && \
    /usr/local/bin/docker-php-ext-install xmlwriter xsl zip bcmath calendar ctype && \
    /usr/local/bin/docker-php-ext-install exif && \
    /usr/local/bin/docker-php-ext-install fileinfo

RUN \
    rm -v /usr/local/etc/php/conf.d/ext-ctype.ini \
          /usr/local/etc/php/conf.d/ext-curl.ini \
          /usr/local/etc/php/conf.d/ext-dom.ini \
          /usr/local/etc/php/conf.d/ext-fileinfo.ini \
          /usr/local/etc/php/conf.d/ext-json.ini \
          /usr/local/etc/php/conf.d/ext-pdo.ini \
          /usr/local/etc/php/conf.d/ext-phar.ini \
          /usr/local/etc/php/conf.d/ext-posix.ini \
          /usr/local/etc/php/conf.d/ext-simplexml.ini \
          /usr/local/etc/php/conf.d/ext-xml.ini \
          /usr/local/etc/php/conf.d/ext-xmlreader.ini \
          /usr/local/etc/php/conf.d/ext-xmlwriter.ini \
          /usr/local/etc/php/conf.d/ext-tokenizer.ini

RUN \
  pecl install redis \
  && echo "extension=redis.so" > /usr/local/etc/php/conf.d/ext-redis.ini

# ssh2 module
RUN \
  pecl install ssh2 channel://pecl.php.net/ssh2-0.12 \
  && echo "extension=ssh2.so" > /usr/local/etc/php/conf.d/ext-ssh2.ini

# composer
RUN \
    cd /usr/local/bin && \
    curl -sS https://getcomposer.org/installer | php && \
    cd -

ADD ./php.ini /usr/local/etc/php/conf.d/php.ini




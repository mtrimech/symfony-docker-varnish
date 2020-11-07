FROM chialab/php:7.4-fpm as php_fpm

RUN apt-get update && apt-get install -y unzip zip libaio-dev
## Install dependencies
RUN apt-get install -y vim nano supervisor sudo wget nginx

## Install composer and Symfony inside docker container
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# Config server time
COPY ./config/timezone/timezone.conf /etc/timezone
RUN rm /etc/localtime && dpkg-reconfigure -f noninteractive tzdata

# Configuration nginx
RUN rm /etc/nginx/sites-enabled/*
COPY ./config/nginx/default.conf /etc/nginx/sites-enabled/

# Configuration supervisor
COPY ./config/supervisor/supervisor.conf /etc/supervisor/conf.d

# Configuration php.ini
RUN ln -s $PHP_INI_DIR/php.ini-production $PHP_INI_DIR/php.ini
COPY ./config/php/php.ini $PHP_INI_DIR/conf.d/symfony.ini

# Start services with supervisor
CMD ["/usr/bin/supervisord"]

WORKDIR /var/www

FROM newsdev/varnish:4.1.0 as varnish
ENV VARNISH_MEMORY 100m

# Config server time
COPY ./config/timezone/timezone.conf /etc/timezone
RUN rm /etc/localtime && dpkg-reconfigure -f noninteractive tzdata

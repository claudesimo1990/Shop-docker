FROM php:8.0.3-fpm

MAINTAINER Claude Simo <claudesimo1990@gmail.com>

ARG phpini
ARG http_proxy
ARG https_proxy

ENV http_proxy="$http_proxy"
ENV https_proxy="$https_proxy"

### FOR DEVELOPMENT ONLY
ARG development
ARG useproxy
RUN if [ "$useproxy" -eq "1" ]; then pear config-set http_proxy $http_proxy; fi
RUN if [ "$useproxy" -eq "1" ]; then echo "Acquire::http::Pipeline-Depth 0;" >> /etc/apt/apt.conf.d/99fixbadproxy; fi
RUN if [ "$useproxy" -eq "1" ]; then echo 'Acquire::http::No-Cache true;' >> /etc/apt/apt.conf.d/99fixbadproxy; fi
RUN if [ "$useproxy" -eq "1" ]; then echo "Acquire::BrokenProxy true;" >> /etc/apt/apt.conf.d/99fixbadproxy; fi

# Install additional software
RUN apt-get update \
    && docker-php-ext-install exif \
    && docker-php-ext-enable exif \
    && apt-get install -y \
        git \
        zip \
        zlib1g-dev \
        libicu-dev \
        g++ \
        libxml2-dev \
        libxslt1-dev \
        libbz2-dev \
        libcurl4-openssl-dev \
        file \
        libssl-dev \
       libonig-dev \
        libzip-dev \
    && CFLAGS="-I/usr/src/php" docker-php-ext-install xmlreader \
    && docker-php-ext-configure intl \
    && docker-php-ext-install -j$(nproc) \
        iconv \
        opcache \
        pdo \
        pdo_mysql \
        mysqli \
        intl \
        json \
        xsl \
        simplexml \
        posix \
        mbstring \
        bz2 \
        curl \
        dom \
        fileinfo \
        ftp \
        pcntl \
        zip \
        soap \
        exif \
&& apt-get autoremove -y \
    && apt-get remove -y autoconf automake libtool nasm make pkg-config libz-dev build-essential g++ \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* ~/.composer \
&& echo "Fertig"

RUN docker-php-ext-install mysqli pdo pdo_mysql

RUN apt-get update && \
apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libpng-dev git && \
docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ && \
docker-php-ext-install gd

RUN docker-php-ext-install pcntl

# PHP konfigurieren
COPY config/$phpini /usr/local/etc/php/conf.d/abus.ini

# PHP-FPM konfigurieren
COPY config/php-fpm.conf /usr/local/etc/php-fpm.d/z_last_abus.conf

# Install composer
RUN curl -sS https://getcomposer.org/installer | \
    php -- --install-dir=/usr/local/bin --filename=composer

# Install xdebug
#RUN if [ "$development" -eq "1" ]; then yes | pecl install xdebug-3.0.4 \
#    && mkdir /var/log/xdebug \
#    && touch /var/log/xdebug/remote.log \
#    && chmod 777 /var/log/xdebug/remote.log \
#    && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
#    && echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/xdebug.ini \
#    && echo "xdebug.idekey=PHPSTORM" >> /usr/local/etc/php/conf.d/xdebug.ini \
#    && echo "xdebug.max_nesting_level=1000" >> /usr/local/etc/php/conf.d/xdebug.ini; fi

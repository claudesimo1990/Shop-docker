FROM php:8.0.7-fpm

MAINTAINER Claude SImo <jeanclaude.simo@abus-kransysteme.de>

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
RUN apt-get update && apt-get install -y \
        git \
        zip \
        zlib1g-dev \
        libicu-dev \
        g++ \
        libldap2-dev \
        libxml2-dev \
        libxslt1-dev \
        libbz2-dev \
        libcurl4-openssl-dev \
        file \
        libssl-dev \
        libonig-dev \
        libzip-dev \
        wget \
        ldap-utils \
    && CFLAGS="-I/usr/src/php" docker-php-ext-install xmlreader \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
    && docker-php-ext-configure intl \
    && docker-php-ext-install -j$(nproc) \
        iconv \
        opcache \
        pdo \
        pdo_mysql \
        mysqli \
        ldap \
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
&& apt-get autoremove -y \
    && apt-get remove -y autoconf automake libtool nasm make pkg-config libz-dev build-essential g++ \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* ~/.composer \
&& echo "Fertig"

# PHP konfigurieren
COPY config/$phpini /usr/local/etc/php/conf.d/abus.ini

# LDAP konfigurieren
COPY config/ldap.conf /etc/ldap/ldap.conf
RUN chmod 774 /etc/ldap/ldap.conf
COPY config/abus_ldap.cert abus_ldap.cert
RUN cat abus_ldap.cert >> /etc/ssl/certs/ca-certificates.crt
RUN rm abus_ldap.cert
RUN chmod 774 /etc/ssl/certs/ca-certificates.crt

# Install composer
RUN curl -sS https://getcomposer.org/installer | \
    php -- --install-dir=/usr/local/bin --filename=composer

# Install Symfony CLI
RUN wget https://get.symfony.com/cli/installer -O - | bash \
    && mv /root/.symfony/bin/symfony /usr/local/bin/symfony

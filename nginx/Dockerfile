FROM nginx:1.21.1

MAINTAINER Dirk Blicker <dirk.blicker@abus-kransysteme.de>

ARG nginxconf

RUN rm /etc/nginx/conf.d/default.conf

COPY config/$nginxconf /etc/nginx/nginx.conf

COPY config/mime.types /etc/nginx/mime.types

RUN mkdir /tmp/nginx && mkdir /tmp/nginx/cache

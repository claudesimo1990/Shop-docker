#!/bin/bash

cron -f &

su - www-data

/usr/local/bin/php /var/www/html/bin/console api:ldap2redis

docker-php-entrypoint php-fpm

FROM alpine:3.10

# Install packages
RUN apk update && apk --no-cache add \
    php7 php7-fpm php7-pdo php7-pdo_mysql php7-json php7-openssl php7-curl \
    php7-mbstring php7-zip php7-xml php7-tokenizer php7-session \
    curl \
    && rm -rf /var/cache/apk/*

COPY config/fpm-pool.conf /etc/php7/php-fpm.d/www.conf
COPY config/php.ini /etc/php7/conf.d/cray_custom.ini

# Add application
COPY --chown=nobody ./laravel /var/www/html

WORKDIR /var/www/html
RUN chmod 777 ./storage/logs && \
    find ./storage/logs -type f -name '*.log' -exec rm '{}' \; && \
    find ./storage/framework -type d -exec chmod 777 '{}' \;

EXPOSE 9000

CMD ["php-fpm7", "-F"]

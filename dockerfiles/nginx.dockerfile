FROM nginx:1.17

# Configure nginx
COPY config/nginx-app.conf /etc/nginx/conf.d/app.conf

# Add application
COPY --chown=nginx ./laravel /var/www/html

WORKDIR /var/www/html

EXPOSE 8080

STOPSIGNAL SIGTERM

CMD ["nginx", "-g", "daemon off;"]

# Configure a healthcheck to validate that everything is up&running
HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1:8080/fpm-ping
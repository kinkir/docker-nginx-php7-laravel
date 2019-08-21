# Docker + NGINX + PHP7 + Laravel 5.8

This repository will provide you a fully functional Laravel app running in docker compose with multiple services, as below:

- Alpine with PHP7-FPM and Laravel app
- NGINX
- MySQL 8
- Redis 5

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

Make sure you have composer installed on your machine, and of course the Docker.

If you're on Linux or MacOS, do the below to install composer.

```bash
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === 'a5c698ffe4b8e849a443b120cd5ba38043260d5c4023dbf93e1558871f1f07f58274fc6f4c93bcfd858c6bd0775cd8d1') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"

# moved it to your path
mv composer.phar /usr/local/bin/composer
```

For alternative methods please refer to https://getcomposer.org/download/

### Installing

Clone this repo on your machine, open a terminal and go to the repository directory.

```bash
# Run composer install the laravel dependencies packages
cd ./laravel && composer install
# Copy environment file from the template
cp .env.example .env
# Generate an APP key
php artisan key:generate
# Update the configurations of database and redis accordingly (link docker services)
sed -i 's/APP_URL=http:\/\/localhost/APP_URL=http:\/\/cray-nginx:8080/' .env
sed -i 's/DB_HOST=127.0.0.1/DB_HOST=cray-mysql/' .env
sed -i 's/DB_DATABASE=homestead/DB_DATABASE=laravel/' .env
sed -i 's/DB_USERNAME=homestead/DB_USERNAME=root/' .env
sed -i 's/DB_PASSWORD=secret/DB_PASSWORD=root/' .env
sed -i 's/REDIS_HOST=127.0.0.1/REDIS_HOST=cray-redis/' .env
sed -i 's/SESSION_DRIVER=file/SESSION_DRIVER=redis/' .env
sed -i 's/CACHE_DRIVER=file/CACHE_DRIVER=redis/' .env
```

You're done with the initial setup now.

Proceed to run `php artisan migrate` to create basic Laravel tables.

```bash
/var/www/html # php artisan migrate

Migration table created successfully.
Migrating: 2014_10_12_000000_create_users_table
Migrated:  2014_10_12_000000_create_users_table (1.22 seconds)
Migrating: 2014_10_12_100000_create_password_resets_table
Migrated:  2014_10_12_100000_create_password_resets_table (0.49 seconds)
```

Connect to your MySQL docker and see if these tables are created

```bash
/var/www/html # mysql -h cray-mysql -u root -p

MySQL [(none)]> use laravel;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
MySQL [laravel]> show tables;
+-------------------+
| Tables_in_laravel |
+-------------------+
| migrations        |
| password_resets   |
| users             |
+-------------------+
3 rows in set (0.004 sec)
```

Now open your browser and go to _http://localhost:8001_, you should see a Laravel welcome index page.

![Laravel Index Page](https://i.imgur.com/zpM0Qhq.png "Laravel Index Page")

Now it's time to check if the Redis is working as well, you should have at least one entry in Redis DB "0" if you managed to load the Laravel index page successfully

Connect to the Redis container by running `redis-cli -h cray-redis` in your terminal

```bash
/var/www/html # redis-cli -h cray-redis
cray-redis:6379> select 0
OK
cray-redis:6379> keys *
1) "laravel_database_laravel_cache:U8P1CaUFLJg5jeWUKJPurzKblOaxM2UZzdtiL2BV"
```

You're all done now and it's ready to start the development using this setup.

## Deployment

Additional deployment info will be included later which talks about how to use Bitbucket Pipelines for the deployment automation to Amazon ECR (Docker Registry) and ECS (Run container services on a cluster).

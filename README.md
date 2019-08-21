# Docker + NGINX + PHP7 + Laravel 5.8

This repository will provide you a fully functional Laravel app running in multi-containers with docker compose, as below:

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

Bring up the docker by issue the command `docker-compose up` in your terminal.

```bash
> docker-compose up
Recreating cray-laravel ... done
Starting cray-redis     ... done
Recreating cray-mysql   ... done
Recreating cray-nginx   ... done
Attaching to cray-redis, cray-laravel, cray-mysql, cray-nginx
cray-redis | 1:C 21 Aug 2019 05:00:09.930 # oO0OoO0OoO0Oo Redis is starting oO0OoO0OoO0Oo
cray-redis | 1:C 21 Aug 2019 05:00:09.930 # Redis version=5.0.5, bits=64, commit=00000000, modified=0, pid=1, just started
cray-redis | 1:C 21 Aug 2019 05:00:09.930 # Warning: no config file specified, using the default config. In order to specify a config file use redis-server /path/to/redis.conf
cray-redis | 1:M 21 Aug 2019 05:00:09.933 * Running mode=standalone, port=6379.
cray-redis | 1:M 21 Aug 2019 05:00:09.933 # WARNING: The TCP backlog setting of 511 cannot be enforced because /proc/sys/net/core/somaxconn is set to the lower value of 128.
cray-redis | 1:M 21 Aug 2019 05:00:09.933 # Server initialized
cray-redis | 1:M 21 Aug 2019 05:00:09.933 # WARNING overcommit_memory is set to 0! Background save may fail under low memory condition. To fix this issue add 'vm.overcommit_memory = 1' to /etc/sysctl.conf and then reboot or run the command 'sysctl vm.overcommit_memory=1' for this to take effect.
cray-redis | 1:M 21 Aug 2019 05:00:09.933 # WARNING you have Transparent Huge Pages (THP) support enabled in your kernel. This will create latency and memory usage issues with Redis. To fix this issue run the command 'echo never > /sys/kernel/mm/transparent_hugepage/enabled' as root, and add it to your /etc/rc.local in order to retain the setting after a reboot. Redis must be restarted after THP is disabled.
cray-redis | 1:M 21 Aug 2019 05:00:09.933 * DB loaded from disk: 0.000 seconds
cray-redis | 1:M 21 Aug 2019 05:00:09.933 * Ready to accept connections
cray-laravel | [21-Aug-2019 05:00:10] NOTICE: fpm is running, pid 1
cray-laravel | [21-Aug-2019 05:00:10] NOTICE: ready to handle connections
cray-mysql | 2019-08-21T05:00:12.041255Z 0 [Warning] [MY-011070] [Server] 'Disabling symbolic links using --skip-symbolic-links (or equivalent) is the default. Consider not using this option as it' is deprecated and will be removed in a future release.
cray-mysql | 2019-08-21T05:00:12.041365Z 0 [System] [MY-010116] [Server] /usr/sbin/mysqld (mysqld 8.0.17) starting as process 1
cray-mysql | 2019-08-21T05:00:13.147770Z 0 [Warning] [MY-010068] [Server] CA certificate ca.pem is self signed.
cray-mysql | 2019-08-21T05:00:13.155329Z 0 [Warning] [MY-011810] [Server] Insecure configuration for --pid-file: Location '/var/run/mysqld' in the path is accessible to all OS users. Consider choosing a different directory.
cray-mysql | 2019-08-21T05:00:13.201104Z 0 [System] [MY-010931] [Server] /usr/sbin/mysqld: ready for connections. Version: '8.0.17'  socket: '/var/run/mysqld/mysqld.sock'  port: 3306  MySQL Community Server - GPL.
cray-mysql | 2019-08-21T05:00:13.450277Z 0 [System] [MY-011323] [Server] X Plugin ready for connections. Socket: '/var/run/mysqld/mysqlx.sock' bind-address: '::' port: 33060
```

SSH to the Laravel container `docker exec --rm -it cray-laravel sh` and run `php artisan migrate` to create basic Laravel tables.

```bash
> docker exec -it cray-laravel sh

/var/www/html # php artisan migrate

Migration table created successfully.
Migrating: 2014_10_12_000000_create_users_table
Migrated:  2014_10_12_000000_create_users_table (1.22 seconds)
Migrating: 2014_10_12_100000_create_password_resets_table
Migrated:  2014_10_12_100000_create_password_resets_table (0.49 seconds)
```

Connect to your MySQL container from the Laravel container and see if these tables are created

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

Connect to the Redis container by running `redis-cli -h cray-redis` in the Laravel container

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

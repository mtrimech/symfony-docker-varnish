# Symfony project with Nginx and Varnish

An empty symfony project built with docker.

# Requirements

You can run this project on your local machine windows/mac.

It is possible also to run on VM linux (I recommend this option)

1. Docker Engine v19.03.13
2. Docker compose v1.27.4
3. VirtualMachine

# Getting started
You have just to clone this repository on your virtual machine

    git clone https://github.com/mtrimech/symfony-docker-varnish my_project
    
# Run
    
    cd my_project/docker
    docker-compose up -d 

Then open your browser and navigate to http://localhost

#### Note : 
* The nginx service is running under 8080 port, because the 80 port is reserved for the reverse proxy server(Varnish)
* Nginx is installed under php container, and it's running with supervisor # see the configuration file under docker/config/supervisor

# Varnish
The varnish container is used as reverse proxy, coming with default configuration file (docker/default.vcl)

If you got a 503 varnish error, please check this configuration

    backend default {
        .host = "162.11.1.2"; # This ip address of the php container
        .port = "80";
    } 
    
# Redis :
    
This project is already configured with redis, take a look at config/packages/sync_redis.yaml and config/packages/framework.yaml

# Mailcatcher (Only for dev)

Open the browser on port 1080

All sent emails from your application are redirected to the Mailcatcher service

#Development

    echo REDIS_URL=redis://redis > .env
    echo MAILER_DSN=smtp://mailcatcher > .env

#Production

    echo REDIS_URL=redis://redis > docker/prod/.env
    echo MYSQL_ROOT_USER=your_awesom_username > docker/prod/.env
    echo MYSQL_ROOT_PASSWORD=your_awesom_password > docker/prod/.env
    echo RABBIT_MQ_USER_NAME=your_awesom_username > docker/prod/.env
    echo RABBIT_MQ_USER_PASSWORD=your_awesom_password > docker/prod/.env

    docker-compose up -d

# Composer install & Prepare project

    docker-compose exec php bash
    mv .env-example .env
    composer install
    php bin/console do:da:cr --if-not-exists
    php bin/console do:sc:up --force

##### Setting up cache and log directories access

    mkdir -p var/cache var/log
    chmod -R 777 var/cache var/log

# Networks

All containers are running on the same network 162.11.1.0

* MySQL 162.11.1.101
* Php 162.11.1.102
* Varnish 162.11.1.103
* Redis 162.11.1.104
* Rabbitmq 162.11.1.105
* Mailcatcher 162.11.1.106 (This is not available on dev environment)

# !Enjoy

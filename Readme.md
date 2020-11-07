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

###The .env file

    echo REDIS_URL=redis://redis > .env


# !Enjoy

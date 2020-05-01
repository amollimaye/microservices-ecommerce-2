# microservices-ecommerce-2
Code for Blog Lets Build Microservice part 2

## Blog link : - 

## Steps to run the code:

This code is derived from NGINX demo code to show Dynamic Reconfiguration of Upstream servers with open source NGINX using Consul & Consul-Template

Code for blog: https://github.com/amollimaye/microservices-ecommerce-2


This demo shows NGINX being used in conjuction with Consul, a popular Service discovery platform and Consul-Template, a generic template rendering tool that provides a convenient way to populate values from Consul into the file system using a daemon.

This demo is based on docker and spins' up the following containers:

*   [Consul](http://www.consul.io) for service discovery
*   Ecommerce service
*   Product service
*   Image service
*   [NGINX](http://nginx.org/) Open Source.

## Prerequisites and Required Software

The following software needs to be installed:

*   [Docker for Mac](https://www.docker.com/products/docker#/mac) if you are running this locally on your MAC **OR** [docker-compose](https://docs.docker.com/compose/install) if you are running this on a linux VM

## Setting up the demo

1.  NGINX will be listening on port 80 on your docker host.

    1.  If you are using Docker Toolbox, you can get the IP address of your docker-machine (default here) by running

    ```
    $ docker-machine ip default
    192.168.99.100
    ```
    Below command should show you the value of HOST_IP env variable. It should show value 192.168.99.100
    ` echo %HOST_IP% `
    
    2.  If you are using Docker for Mac, the IP address you need to use is 172.17.0.1

    Export this IP into an environment variable HOST_IP by running `export HOST_IP=192.168.99.100` OR `export HOST_IP=172.17.0.1` (used by docker-compose.yml below)

2.  Now open the 'microservices' folder where docker-compose file is located.
    Run below command to spin up all the containers run:

    `$ docker-compose up -d`

    You should have a bunch of containers up and running:

    ```
    $ docker ps

    CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                                                                            NAMES
    eae2bb1c514f        nginx:latest        "/usr/bin/runsvdir /…"   8 seconds ago       Up 8 seconds        443/tcp, 0.0.0.0:8080->8080/tcp                                                  nginx
    e41419fbe276        ecommerce:latest    "java -Djava.securit…"   9 seconds ago       Up 9 seconds        8090/tcp                                                                         microservices_ecommerce_1
    6c4646c4d954        progrium/consul     "/bin/start -server …"   9 seconds ago       Up 9 seconds        53/tcp, 53/udp, 8300-8302/tcp, 8400/tcp, 8301-8302/udp,0.0.0.0:8500->8500/tcp   consul
    9a1c011c6bbd        images:latest       "java -Djava.securit…"   9 seconds ago       Up 9 seconds        8090/tcp                                                                         microservices_images_1
    ad895270cd67        product:latest      "java -Djava.securit…"   9 seconds ago       Up 9 seconds        8090/tcp                                                                         microservices_product_1

## Running the demo

NGINX is listening on port 80 on your Docker Host, and runs Consul Template. Consul Template listens to Consul for changes to the service catalog, rewrites Nginx config file and reloads Nginx on any changes.

So now just go to `http://<HOST-IP>:8500` (Note: Docker for Mac runs on IP address 127.0.0.1) . You will see Consul UI page showing the list of all registered services.

Below command will show the dynamically updated nginx configuration

```
$ docker exec nginx nginx -T

 configuration file /etc/nginx/conf.d/app.conf:

upstream consul {
    zone upstream-consul 64k;
    least_conn;
    server 192.168.99.100:8300 max_fails=3 fail_timeout=60 weight=1;

}
upstream ecommerceApp {
    zone upstream-ecommerceApp 64k;
    least_conn;
    server e41419fbe276:9080 max_fails=3 fail_timeout=60 weight=1;

}
upstream imageApp {
    zone upstream-imageApp 64k;
    least_conn;
    server 9a1c011c6bbd:9090 max_fails=3 fail_timeout=60 weight=1;

}
upstream productApp {
    zone upstream-productApp 64k;
    least_conn;
    server ad895270cd67:8090 max_fails=3 fail_timeout=60 weight=1;

}

server {
    listen 8080 default_server;

    location / {
        root /usr/share/nginx/html/;
        index index.html;
    }

    location /stub_status {
        stub_status;
    }


    location /consul {
        proxy_pass http://consul;
        rewrite ^/consul/(.*)$ /$1 break;
    }

    location /ecommerceApp {
        proxy_pass http://ecommerceApp;
        rewrite ^/ecommerceApp/(.*)$ /$1 break;
    }

    location /imageApp {
        proxy_pass http://imageApp;
        rewrite ^/imageApp/(.*)$ /$1 break;
    }

    location /productApp {
        proxy_pass http://productApp;
        rewrite ^/productApp/(.*)$ /$1 break;
    }

}
```

From here you can scale up the ecommerce service:

```
$ docker-compose up -d --scale ecommerce=3
Starting microservices_ecommerce_1 ...
microservices_product_1 is up-to-date
consul is up-to-date
nginx is up-to-date
Starting microservices_ecommerce_1 ... done
Creating microservices_ecommerce_2 ... done
Creating microservices_ecommerce_3 ... done
```

You can again run above command to see the updated nginx configuration once services start.
The upstream will be updated as below:
```
upstream ecommerceApp {
    zone upstream-ecommerceApp 64k;
    least_conn;
    server d8414b9686d5:9080 max_fails=3 fail_timeout=60 weight=1;
    server e41419fbe276:9080 max_fails=3 fail_timeout=60 weight=1;
    server e3f6bedd2c67:9080 max_fails=3 fail_timeout=60 weight=1;

}
```

Scale down using below command.

```
$ docker-compose scale ecommerce=3
```

All the changes should be automatically reflected in the NGINX config file (/etc/nginx/conf.d/app.conf) inside the NGINX container.

Any changes like stopping a container should be updated to consul and hence nginx config.

```
$ docker stop microservices_ecommerce_2
microservices_ecommerce_2
```

On the Consul UI page (http://<HOST-IP>:8500/ui/#/dc1/services/ecommerceApp), you will observe the change and the container removed. Also the NGINX config file (`/etc/nginx/conf.d/app.conf`) will have just 2 server entries now indicating that the 3rd server entry corresponding to the container which was stopped was removed automatically.

## Windows issues and solutions:



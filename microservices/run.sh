#!/bin/sh
docker-compose down
export HOST_IP=192.168.99.100
docker-compose up

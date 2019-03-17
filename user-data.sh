#!/bin/bash

# install Docker

sudo apt-get update &&  sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - && sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable" && sudo apt-get update && sudo apt-get install docker-ce docker-ce-cli containerd.io -y

# download wp files

sudo wget https://ru.wordpress.org/latest-ru_RU.tar.gz
sudo tar -xzvf latest-ru_RU.tar.gz
mkdir /app
sudo chmod 777 /app
sudo cp -r wordpress/* /app

# write wp-config.php

cd /app && sudo wget https://raw.githubusercontent.com/notariuss/wordpress-cluster/master/wp-config.php

# start docker

sudo docker run -p 80:80 -v /app:/app fruitydev/nginx-php
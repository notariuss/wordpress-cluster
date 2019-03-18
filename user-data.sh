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

# install nfs-common

sudo apt-get install nfs-common -y

# install efs

git clone https://github.com/aws/efs-utils
sudo apt-get -y install binutils
cd efs-utils
./build-deb.sh
sudo apt-get -y install ./build/amazon-efs-utils*deb

# mount

sudo mount -t efs fs-7156cc28:/ /app
sudo chown 700:700 -R /app

# start docker

sudo docker run -p 80:80 -v /app:/app fruitydev/nginx-php
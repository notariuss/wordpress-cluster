docker build . -t fruitydev/nginx-php
docker run -v ~/Documents/app:/app -p 80:80 -d fruitydev/nginx-php


docker build . -t nginx-php
docker run -v ~/Documents/app:/app -p 80:80 -d nginx-php
docker run -e MYSQL_ROOT_PASSWORD=123123 -p 3306:3306 -d mysql:5.7


docker build . -t fruitydev/nginx-php
docker run -v ~/Documents/app:/app -p 80:80 -d fruitydev/nginx-php
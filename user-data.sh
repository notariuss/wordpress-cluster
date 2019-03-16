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

# download wp files

sudo wget https://ru.wordpress.org/latest-ru_RU.tar.gz
sudo tar -xzvf latest-ru_RU.tar.gz
mkdir /app
sudo chmod 777 /app
sudo cp -r wordpress/* /app

# write wp-config.php

sudo echo "
<?php

define( 'DB_NAME', 'wordpress' );

define( 'DB_USER', 'watermelon' );

define( 'DB_PASSWORD', 'GagarinInTheSpac3' );

define( 'DB_HOST', 'wordpress-new.cluster-ccx4pjir0nbf.eu-central-1.rds.amazonaws.com' );

define( 'DB_CHARSET', 'utf8mb4' );

define( 'DB_COLLATE', '' );


define( 'AUTH_KEY',         'T24b>rHI-Pf=A!%wvF{cjn&q#<!FR+G2 @uv)=mkwSz)<~E)UBLx;nKi2jNB/i9~' );
define( 'SECURE_AUTH_KEY',  'ZG(E?&eyjY%6:l+ph>KO?}}HB!4$?Zgxf]$ngKR!W_j)@G%NhH}w/Z?b&|trW5tm' );
define( 'LOGGED_IN_KEY',    '=^^z1=3_w]rQ<S/_j2zyfeR2w7}[J<HT/O&3RS&I|!yZ9RL;|Tx)U^3%j`,8x?4P' );
define( 'NONCE_KEY',        'qb;9Rl!xf7$+gvX7yyMAby,Qo*&AzkW(^(,ljF{sRlOJa Ha.+;PF%?$,T.Gi%Ye' );
define( 'AUTH_SALT',        '),s$zGc@PRH:S$|7=@@!2BFZm@cG|z{Dyg%G,hFgb@~Hqr_+P42-m|Tb{AE<KfIO' );
define( 'SECURE_AUTH_SALT', '1W|^UOZ1D&x88<,9OCVZ*5[e5#9 #qw.A>!d(m{Y 4H:2($JpBW-KzoNJTsj(}>W' );
define( 'LOGGED_IN_SALT',   '=|3<VQ!V[ LPykRt[s;5;M BVC*z~~|+3>)9tfDq0X93FK(o_ @IV4guow%tLWoF' );
define( 'NONCE_SALT',       '6G1T_0LVBZMG_mv79hE+VDxUZg]A9j.ag9,P8tp22wadPm^(E4RM:&Lbwqns<%6L' );

$table_prefix = 'wp2_';

define( 'WP_DEBUG', false );

if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', dirname( __FILE__ ) . '/' );
}
" > /app/wp-config.php

require_once( ABSPATH . 'wp-settings.php' );

EOF

# start docker

sudo docker run -p 80:80 -v /app:/app webdevops/php-apache:7.3
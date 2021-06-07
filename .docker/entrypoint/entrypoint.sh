#!/bin/sh

composer install


cp .env.example .env

cp .htaccess public/.htaccess

curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
apt-get install -y nodejs

npm install

npm run dev

chmod ugoa+-=rw- ./storage

/usr/bin/supervisord -n > /dev/null 2>&1 &
/usr/sbin/apache2ctl -D FOREGROUND
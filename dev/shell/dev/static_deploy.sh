#!/bin/sh

NGINX=/usr/local/nginx
SOURCE_HOME=/opt/source/dev

if [ $# != 1 ]; then
  echo "please specify branch"
  exit
fi

echo "deploying "$1

cp $SOURCE_HOME/misc/nginx/test/nginx.conf.ydyw $NGINX/conf
cp $SOURCE_HOME/misc/nginx/thumbnail.lua $NGINX/conf
cd $NGINX/conf
sed -i "s#BRANCH#$1#" nginx.conf.ydyw
rm -f nginx.conf
mv nginx.conf.ydyw nginx.conf

nginx -s reload

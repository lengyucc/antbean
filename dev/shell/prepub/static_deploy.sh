#!/bin/sh

NGINX=/usr/local/nginx
SOURCE_HOME=/opt/source/dev
STATIC_HOME=/static_svn
STATIC_HOST=10.26.248.130

if [ $# != 2 ]; then
  echo "please specify env & branch"
  exit
fi

cd $SOURCE_HOME
svn up

if [ "$1" = "pre" ]; then
  cd $SOURCE_HOME/misc/nginx/prepub
  cp nginx.conf.ydyw $NGINX/conf
  cd $NGINX/conf
  sed -i "s#BRANCH#$2#" nginx.conf.ydyw
  rm -f nginx.conf
  mv nginx.conf.ydyw nginx.conf

  echo "deploying "$2

  cd $SOURCE_HOME/misc/
  cp MP_veri* /static_svn

  SOURCE_HOME2=$SOURCE_HOME/$2

  cd /static_svn/static
  rm -rf *
  cd $SOURCE_HOME2
  echo $SOURCE_HOME2
  cp -r static/* /static_svn/static

  cd $SOURCE_HOME
  cp misc/js/prepub/common-app.js /static_svn/static/app/js
  cd /static_svn/static/app/js
  rm -f common.js
  mv common-app.js common.js

  cd $SOURCE_HOME
  cp misc/js/prepub/common-wx.js /static_svn/static/wx/js
  cd /static_svn/static/wx/js
  rm -f common.js
  mv common-wx.js common.js

  nginx -s reload
elif [ "$1" = "production" ]; then
  echo "deploy production static to "$STATIC_HOST
  ssh root@$STATIC_HOST "nginx -s stop"
  ssh root@$STATIC_HOST "cd $STATIC_HOME; rm -rf static"
  scp -r $SOURCE_HOME/$2/static root@$STATIC_HOST:/static_svn

  cd $SOURCE_HOME/misc/js/production/
  cp common-app.js ~
  cd ~
  mv common-app.js common.js
  scp ~/common.js root@$STATIC_HOST:/static_svn/static/app/js
  rm -f ~/common.js

  cd $SOURCE_HOME/misc/js/production/
  cp common-wx.js ~
  cd ~
  mv common-wx.js common.js
  scp ~/common.js root@$STATIC_HOST:/static_svn/static/wx/js
  rm -f ~/common.js

  cd $SOURCE_HOME/misc/
  scp MP_veri* root@$STATIC_HOST:/static_svn/

  ssh root@$STATIC_HOST "nginx"
  echo "static updated!"
else
  exit
fi

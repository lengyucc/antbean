#!/bin/sh

SOURCE_HOME=/opt/source/dev
TOMCAT_HOME=/opt/tomcat
LOG=/opt/deploy/logs
BUILD=`pwd`

if [ $# != 1 ]; then
  echo "please specify branch"
  exit
fi

echo "deploying "$1

cd $SOURCE_HOME
svn up
echo "source updated!"

SOURCE_HOME=$SOURCE_HOME/$1
if [ ! -d $SOURCE_HOME ]; then
    echo "invalid branch "$1
    exit
fi

rm -f ~/antx.properties
cd /opt/source/dev/misc/antx.properties/test
cp antx.properties.admin ~/antx.properties
cd ~
sed -i "s#BRANCH#$1#" antx.properties
echo "antx.properties updated"

cd $SOURCE_HOME/ydyw-all
mvn clean install -Dmaven.test.skip

if [ $? -eq 0 ];then
  echo "maven build successful."
else
  echo "maven build fail."
  exit
fi

cd $TOMCAT_HOME/bin
sh shutdown.sh
ps -ef | grep 'tomcat' | grep -v grep| awk '{print $2}' | xargs kill -9 
sleep 5

rm -rf $TOMCAT_HOME/webapps/ydyw-admin*
rm -rf $TOMCAT_HOME/webapps/ROOT
cp $SOURCE_HOME/ydyw-all/ydyw-admin/target/ydyw-admin.war $TOMCAT_HOME/webapps

set -m
sh catalina.sh start
sleep 5

tail -f $LOG/admin.log -n 300

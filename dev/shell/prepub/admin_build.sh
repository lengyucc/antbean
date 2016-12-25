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

rm -f ~/antx.properties
cd $SOURCE_HOME/misc/antx.properties/prepub
cp antx.properties.admin.prepub ~/antx.properties
cd ~
sed -i "s#BRANCH#$1#" ~/antx.properties
echo "antx.properties updated"

SOURCE_HOME=$SOURCE_HOME/$1

cd $SOURCE_HOME/ydyw-all
mvn clean install -Dmaven.test.skip

if [ $? -eq 0 ];then
  echo "maven build successful."
else
  echo "maven build fail."
  exit
fi

echo >> $LOG/../history/deploy_admin.log
echo `date` admin $1 >> $LOG/../history/deploy_admin.log
echo `cd $SOURCE_HOME; svn info . | grep -E 'Last Changed Author|Last Changed Rev|Relative URL'` >> $LOG/../history/deploy_admin.log

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

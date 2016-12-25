#!/bin/sh

SOURCE_HOME=/opt/source/dev
JBOSS_HOME=/opt/jboss
LOG=/opt/deploy/logs
BUILD=`pwd`

if [ $# != 1 ]; then
  echo "please specify branch"
  exit
fi

echo "deploying "$1

SOURCE_HOME=$SOURCE_HOME/$1

cd /root
cp antx.properties.app antx.properties
sed -i "s#BRANCH#$1#" antx.properties
echo "antx.properties updated"

cd $SOURCE_HOME
svn up
echo "source updated!"

cd $SOURCE_HOME/ydyw-all
mvn clean install -Dmaven.test.skip

if [ $? -eq 0 ];then
  echo "maven build successful."
else
  echo "maven build fail."
  exit
fi

cd /root
rm -f antx.properties

cd $BUILD
sh stop.sh

rm -rf $JBOSS_HOME/standalone/deployments/ydyw-app*
rm -rf $JBOSS_HOME/standalone/deployments/ydyw-task*
cp $SOURCE_HOME/ydyw-all/ydyw-app/target/ydyw-app.war $JBOSS_HOME/standalone/deployments
cp $SOURCE_HOME/ydyw-all/ydyw-task/target/ydyw-task.war $JBOSS_HOME/standalone/deployments

sh start.sh

tail -f $LOG/app.log -n 300

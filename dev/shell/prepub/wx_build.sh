#!/bin/sh

SOURCE_HOME=/opt/source/dev
STATIC_HOME=/mstatic
JBOSS_HOME=/opt/jboss
LOG=/opt/deploy/logs
BUILD=`pwd`

if [ $# != 2 ]; then
  echo "please specify env & branch"
  exit
fi

# rm -rf $SOURCE_HOME/$2
cd $SOURCE_HOME
svn up
echo "source updated!"

rm -f ~/antx.properties
if [ "$1" = "production" ]; then
  echo "production build starts"
  cd $SOURCE_HOME/misc/antx.properties/production
  cp antx.properties.wx.production ~/antx.properties
  cd ~
  sed -i "s#BRANCH#$2#" antx.properties
elif [ "$1" = "pre" ]; then
  echo "prepub build starts"
  cd $SOURCE_HOME/misc/antx.properties/prepub
  cp antx.properties.wx.prepub ~/antx.properties
  cd ~
  sed -i "s#BRANCH#$2#" antx.properties
else
  exit
fi
echo "antx.properties updated"

SOURCE_HOME=$SOURCE_HOME/$2

cd $SOURCE_HOME/ydyw-all
mvn clean install -Dmaven.test.skip

if [ $? -eq 0 ];then
  echo "maven build successful."
else
  echo "maven build fail."
  exit
fi

echo >> $LOG/../history/deploy_wx.log
echo `date` wx $1 $2 >> $LOG/../history/deploy_wx.log
echo `cd $SOURCE_HOME; svn info . | grep -E 'Last Changed Author|Last Changed Rev'` >> $LOG/../history/deploy_wx.log

if [ "$1" = "production" ]; then
  echo "production build ends."
  exit
fi

cd $BUILD
sh stop.sh

rm -rf $JBOSS_HOME/standalone/deployments/ydyw-wx*
cp $SOURCE_HOME/ydyw-all/ydyw-wx/target/ydyw-wx.war $JBOSS_HOME/standalone/deployments

sh start.sh

tail -f $LOG/wx.log -n 300

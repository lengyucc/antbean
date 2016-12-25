#!/bin/sh

WX_HOST=10.26.248.130
TASK_HOST=10.26.248.130
SRC_TEMPLATE_PATH=/opt/source/dev/BRANCH/ydyw-all/ydyw-wx/deploy/templates
DEST_TEMPLATE_PATH=/opt/deploy/wx
WX_WAR=/opt/source/dev/BRANCH/ydyw-all/ydyw-wx/target/ydyw-wx.war
TASK_WAR=/opt/source/dev/BRANCH/ydyw-all/ydyw-task/target/ydyw-task.war

JBOSS_HOME=/opt/jboss
BUILD_DIR=/opt/build

if [ $# != 1 ]; then
  echo "please specify branch"
  exit
fi

SRC_TEMPLATE_PATH=$(echo $SRC_TEMPLATE_PATH | sed "s#BRANCH#$1#")
WX_WAR=$(echo $WX_WAR | sed "s#BRANCH#$1#")
echo $SRC_TEMPLATE_PATH
echo $WX_WAR

scp -r $SRC_TEMPLATE_PATH root@$WX_HOST:$DEST_TEMPLATE_PATH

echo "templates synchronized."

ssh root@$WX_HOST "sh $BUILD_DIR/stop.sh"
ssh root@$WX_HOST "rm -rf $JBOSS_HOME/standalone/deployments/ydyw-wx*"
scp $WX_WAR root@$WX_HOST:$JBOSS_HOME/standalone/deployments
ssh root@$WX_HOST "sh $BUILD_DIR/start.sh"

echo "wx deploy done"


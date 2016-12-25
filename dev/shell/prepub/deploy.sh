#!/bin/sh

APP_HOST=10.26.248.130
TASK_HOST=10.26.248.130
SRC_TEMPLATE_PATH=/opt/source/dev/BRANCH/ydyw-all/ydyw-app/deploy/templates
DEST_TEMPLATE_PATH=/opt/deploy/app
APP_WAR=/opt/source/dev/BRANCH/ydyw-all/ydyw-app/target/ydyw-app.war
TASK_WAR=/opt/source/dev/BRANCH/ydyw-all/ydyw-task/target/ydyw-task.war

JBOSS_HOME=/opt/jboss
BUILD_DIR=/opt/build

if [ $# != 1 ]; then
  echo "please specify branch"
  exit
fi

SRC_TEMPLATE_PATH=$(echo $SRC_TEMPLATE_PATH | sed "s#BRANCH#$1#")
APP_WAR=$(echo $APP_WAR | sed "s#BRANCH#$1#")
echo $SRC_TEMPLATE_PATH
echo $APP_WAR

scp -r $SRC_TEMPLATE_PATH root@$APP_HOST:$DEST_TEMPLATE_PATH

echo "templates synchronized."

ssh root@$APP_HOST "sh $BUILD_DIR/stop.sh"
ssh root@$APP_HOST "rm -rf $JBOSS_HOME/standalone/deployments/ydyw-app*"
scp $APP_WAR root@$APP_HOST:$JBOSS_HOME/standalone/deployments
#ssh root@$APP_HOST "sh $BUILD_DIR/start.sh"

echo "app deploy done"

TASK_WAR=$(echo $TASK_WAR | sed "s#BRANCH#$1#")
echo $TASK_WAR

#ssh root@$TASK_HOST "sh $BUILD_DIR/stop.sh"
ssh root@$TASK_HOST "rm -rf $JBOSS_HOME/standalone/deployments/ydyw-task*"
scp $TASK_WAR root@$TASK_HOST:$JBOSS_HOME/standalone/deployments
ssh root@$TASK_HOST "sh $BUILD_DIR/start.sh"

echo "task deploy done"


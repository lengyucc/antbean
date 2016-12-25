#!/bin/sh

LOG=/opt/deploy/logs
JBOSS_HOME=/opt/jboss

ps aux | grep nginx: | grep -v grep 1>/dev/null
if [ $? -eq 0 ];then
  echo "NGINX alread started!"
else
  echo "start nginx"
  nginx
fi

ps aux | grep standalone | grep jboss | grep -v grep 1>/dev/null
if [ $? -eq 0 ];then
  echo "JBoss alread started!"
else
  nohup sh $JBOSS_HOME/bin/standalone.sh >> $LOG/jboss_out.log 2>&1 &
  echo "JBoss starting ..."
  sleep 10
  echo "JBoss started."
fi



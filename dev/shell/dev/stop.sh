#!/bin/sh

JBOSS_HOME=/opt/jboss

ps aux | grep nginx: | grep -v grep 1>/dev/null
if [ $? -eq 0 ];then
  nginx -s stop 1>/dev/null
  sleep 3
  echo "nginx stopped!"
else
  echo "NGINX alread stopped!"
fi

ps aux | grep standalone | grep jboss | grep -v grep 1>/dev/null
if [ $? -eq 0 ];then
  cd $JBOSS_HOME/bin
  sh jboss-cli.sh --connect --command=:shutdown 1>/dev/null
  
  while true
  do
    ps aux | grep standalone | grep jboss | grep -v grep 1>/dev/null
    if [ $? -eq 0 ];then
      echo "jboss stopping ..."
    else
      echo "JBoss stopped!"
      break
    fi
    sleep 1
  done
else
  echo "JBoss alread stopped!"
fi




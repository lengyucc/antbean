#!/bin/sh 

sh build.sh production trunk
sh deploy.sh trunk

sh wx_build.sh production trunk
sh wx_deploy.sh trunk

sh static_deploy.sh production trunk

#!/bin/sh

sh build.sh pre trunk
sh wx_build.sh pre trunk

sh static_deploy.sh pre trunk

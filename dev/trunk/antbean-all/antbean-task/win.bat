@echo off

cd ../antbean-common
call mvn clean install -Dmaven.test.skip
if %errorlevel% GTR 0 goto END

cd ../antbean-dal
call mvn clean install -Dmaven.test.skip
if %errorlevel% GTR 0 goto END

cd ../antbean-biz
call mvn clean install -Dmaven.test.skip
if %errorlevel% GTR 0 goto END

cd ../antbean-task
call mvn clean install -Dmaven.test.skip
if %errorlevel% GTR 0 goto END

SET MAVEN_OPTS=-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=1066
call mvn jetty:run
SET MAVEN_OPTS= 

:END
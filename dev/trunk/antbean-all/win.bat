@echo off

call mvn eclipse:eclipse
if %errorlevel% GTR 0 goto END

call mvn clean install -Dmaven.test.skip
if %errorlevel% GTR 0 goto END

:END
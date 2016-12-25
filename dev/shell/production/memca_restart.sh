#!/bin/sh

kill `cat /tmp/memcached.pid`
memcached -d -m 1024 -u root -c 128 -p 11211 -P /tmp/memcached.pid

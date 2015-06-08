#!/usr/bin/env bash
#!/bin/bash

gw1=10.15.15.1
gw2=10.16.16.1

host=4.2.2.1
count=5
timeout=20
logfile=/tmp/check.log

route add -host ${host} gw ${gw1}

stat=`ping -n -c$count -w$timeout -q $host`
code=$?
stat=`echo $stat | awk -F'---' '{print $3;}' | awk -Frtt '{print $1}'`

{
if [ $code -eq 0 ]
then
 echo `date` "Success ($code): $stat"
 route del default gw ${gw2}
 route add default gw ${gw1}
else
 echo `date` "Failure ($code): $stat"
 route del default gw ${gw1}
 route add default gw ${gw2}
fi
} 2> /dev/null >> $logfile

#!/bin/bash

[ -f /etc/resolv.conf ]
echo $?

[ -f /etc/resolv.conf ] && echo It\'s there

if  [ -f /etc/resolv.conf ]
then
echo It\'s there
else
echo It\'s not there
fi


if  [ -x /bin/ls ]  
then
echo It\'s executable
else
echo It\'s not executable
fi

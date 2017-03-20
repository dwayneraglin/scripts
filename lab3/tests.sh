#!/bin/bash

[ -f /etc/resolv.conf ]
echo $?

[ -f /etc/resolv.conf ] && echo It\'s there

if  [ -f /etc/resolv.conf ]; then
    echo "/etc/resolv.conf exists"
else
    echo "/etc/resolv.conf does not exist"
fi


if  [ -x /bin/ls ]; then
    echo It\'s executable
    if [ -w /bin/ls ]; then
	echo "/bin/ls is also writable"
    fi
    if [ -r /bin/ls ]; then
	echo "/bin/ls is readable as well"
    fi
else
    echo It\'s not executable
fi

if [ -n $USER ]; then
    echo "USER has something in it"
    echo "The contents of USER is" $USER
fi

# To protect against an empty string use quotes around the variable you are testing for
if [ -n "$FLOOBLE" ]; then
    echo "FLOOBLE has something in it"
else 
    echo "FLOOBLE has nothing in it"
fi


arr=(a b c d)
if [ ${#arr[@]} -lt 1 ]; then
    echo "arr has less than one element"
else
    echo "arr has one or more elements"
fi

arr=(a b c d)
if [ ${#arr[@]} -lt 1 ]; then
    echo "arr has less than one element"
elif [ ${#arr[@]} -gt 1 ]; then
    echo "arr has more than one element"
else 
    echo "arr has exactly one element"
fi


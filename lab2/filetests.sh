#!/bin/bash

if [ -e /etc/resolv.conf ]; then
	echo "/etc/resolv.conf exists"
else
	echo "/etc/resolv.conf does not exist"
fi

if [ -x /bin/ls ]; then
	echo "/bin/ls is executable"
else
	echo "/bin/ls is not executable"
fi

if [ -d /tmp ]; then
        echo "/tmp is a directory"
else
        echo "/tmp is not a directory"
fi

if [ -d /etc/hosts ]; then
        echo "/etc/hosts is a directory"
else
        echo "/etc/hosts is not a directory"
fi

if [ -r /etc/shadow ]; then
        echo "/etc/shadow is readable"
else
        echo "/etc/shadow is not readable"
fi

if [ -w /etc/network/interfaces ]; then
        echo "/etc/network/interfaces is writable"
else
        echo "/etc/network/interfaces is not writable"
fi

if [ -u /bin/passwd ]; then
        echo "/bin/passwd is setuid"
else
        echo "/bin/passwd is not setuid"
fi

if [ /etc/hosts -nt /etc/resolv.conf ]; then
        echo "/etc/hosts is newer than /etc/resolv.conf"
else
        if [ /etc/hosts -ot /etc/resolv.conf ]; then
                echo "/etc/resolv.conf is newer than /etc/hosts"
        else
                echo "/etc/hosts is the same age as /etc/resolv.conf"
        fi
fi

if [ -h /bin/pidof ]; then
        echo "/bin/pidof is a symbolic link"
else
        echo "/bin/pidof is not a symbolic link"
fi

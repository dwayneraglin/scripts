#!/bin/bash
# This script displays some network information

# First we will get the names of the configured interfaces
# There are lots of ways to do this, here are examples using cut, sed, and awk to pull them from ifconfig output

# ifconfig|grep '^[a-zA-Z]'|cut -d\  -f 1
# ifconfig|awk '/^[A-Za-z]/{print $1}'
# ifconfig|sed -n '/^[a-zA-Z]/s/ .*//p'

# Put the extracted interface names into an array
interfaces=($(ifconfig|awk '/^[A-Za-z]/{print $1}'))

# We know there are 2 interfaces, so for each one, do a similar extraction to get the ip address and speed of each interface
ip=($(ifconfig ${interfaces[0]}|sed -n '/inet addr:/s/.*inet addr:\([0-9.][0-9.]*\) .*/\1/p') 
    $(ifconfig ${interfaces[1]}|sed -n '/inet addr:/s/.*inet addr:\([0-9.][0-9.]*\) .*/\1/p'))

# Extract the ip address of the gateway from the output of route -n
gatewayip=$(route -n|awk '/^0.0.0.0/{print $2}')

# get the speeds of the interfaces using ethtool which might need to be installed
speed=($(sudo ethtool ${interfaces[0]} 2>/dev/null|awk '/Speed:/{print $2}')
       $(sudo ethtool ${interfaces[1]} 2>/dev/null|awk '/Speed:/{print $2}'))

if [ ${#interfaces[@]} -gt 0 ]; then

    cat <<EOF

This system has ${#interfaces[@]} interfaces.
They have the following configuration:
EOF

    interfaceindex=0
    while [ $interfaceindex -lt ${#interfaces[@]} ]; do
        echo ${speed[$interfaceindex]} ${interfaces[$interfaceindex]} : ${ip[$interfaceindex]}
        interfaceindex+=1
    done

    cat <<EOF
The default route is through the gateway at $gatewayip
EOF

fi

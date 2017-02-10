#!/bin/bash

# This script creates an array using the output of ifconfig which has the names of the network interfaces in it. 
# It uses these names to extract the ip addresses of the interfaces, also using ifconfig output.
# Finally, it parses the output of route -n to display the ip address of the default gateway.

interfaces=( $(ifconfig | grep '^[A-Za-z]' | awk '{print $1}' ) )

# find the ip address of the interfaces
# ifconfig ${interfaces[0]} | grep 'inet addr:' | sed -n 's/.*addr:\([0-9.][0-9.]*\).*/\1/p'
# or
ip0=$(ifconfig ${interfaces[0]} | sed -n '/inet addr:/s/.*addr:\([0-9.][0-9.]*\).*/\1/p')
echo "Interface ${interfaces[0]} has ip address $ip0"

ip1=$(ifconfig ${interfaces[1]} | sed -n '/inet addr:/s/.*addr:\([0-9.][0-9.]*\).*/\1/p')
echo "Interface ${interfaces[1]} has ip address $ip1"

# extract the default gateway ip address from the route table
# route -n | grep '^0.0.0.0' | awk '{print $2}'
# or
gw=$(route -n | awk '/^0.0.0.0/{print $2}')
echo "My default gateway is through the gateway at $gw"

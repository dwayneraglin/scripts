#!/bin/bash

#Create an array using the output of ifconfig which has the names of
#the network interfaces in it. Use those names to extract the ip 
#addresses of the interfaces, also using ifconfig output. 
#Parse the output of route -n to display the ip address of the default gateway.

declare -a ips

interfacenames=(`ifconfig |grep '^[a-zA-Z]'|awk '{print $1}'`)
numberOfInterfaces=${#interfacenames[@]}
interfacearrayindex=0
while [ $interfacearrayindex -lt $numberOfInterfaces ] ; do
    currentinterfacename=${interfacenames[$interfacearrayindex]}
    ips[$interfacearrayindex]=`ifconfig $currentinterfacename | grep 'inet addr' | sed -e 's/  *inet addr://'| sed -e 's/ .*//'`
    currentinterfaceIPaddress=${ips[$interfacearrayindex]}
    echo "Interface $currentinterfacename has address $currentinterfaceIPaddress"
    interfacearrayindex=$(( $interfacearrayindex +1 ))
done

gatewayip=`route -n|grep '^0.0.0.0 '|awk '{print $2}'`

cat <<EOF
My default gateway is $gatewayip
EOF

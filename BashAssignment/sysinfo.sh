#!/bin/bash
# This script displays a system information summary. It accepts command line options for each item.

# display the hostname
echo The system name is $(hostname)

# display the domain name
echo the configured domain name is $(dnsdomainname)

# display the ip address (need to test how many are in array and output accordingly)
# Put the extracted interface names into an array
interfaces=($(ifconfig|awk '/^[A-Za-z]/{print $1}'))

# We know there are 2 interfaces, so for each one, do a similar extraction to get the ip address and speed of each interface
ip=($(ifconfig ${interfaces[0]}|sed -n '/inet addr:/s/.*inet addr:\([0-9.][0-9.]*\) .*/\1/p') 
    $(ifconfig ${interfaces[1]}|sed -n '/inet addr:/s/.*inet addr:\([0-9.][0-9.]*\) .*/\1/p'))

cat <<EOF
This system has 2 interfaces with following ip addresses:
${interfaces[0]} : ${ip[0]}
${interfaces[1]} : ${ip[1]}
EOF

# display the OS version
echo The OS version is $(cat /etc/*release | awk '/^[VERSION="]/')

# display the OS name
echo The OS Name is $(cat /etc/*release | awk '/^[NAME="]/')

# display the CPU description
echo The system CPU is $(cat /proc/cpuinfo | awk '/^[model info]/')

# display the installed memory
echo This system has $(free -m | awk '/^[Mem:]/')MB of memory installed.

# display the free disk space
echo The system has $(df -h | awk '/^["/dev"]/') of free disk space

# display a list of printer
lpstat

# display a list of installed software
# echo The system has the following software packages installed:
dpkg --get-selections | more

#!/bin/bash
# This script displays requested system information. It accepts command line options for each item, or displays a usage menu if run 
# without any command line options.


#############
# Variables #
#############

errorfile=/tmp/sysinfoerrors.txt
cmdargnum=$#
cmdargs=$@

cpu=$(head /proc/cpuinfo | grep "model name" | sed -e 's/model name//' -e 's/://')
domainname=$(dnsdomainname)
hostname=$(hostname)
memory=$(free -t -h | grep "Mem:" | awk '{print $2}')
#osname=$(cat /etc/*release | awk '/^[NAME="]/' | sed 's/NAME="//' | sed 's/"//')
osname=$(lsb_release -d | sed 's/Description://')
#osname=$(uname)
#osversion=$(cat /etc/*version)
osversion=$(lsb_release -r | sed 's/Release://')
#osversion=$(uname -r)

#############
# Functions #
#############

# Help message
function usage {
	clear
	echo "Usage: ./sysinfo.sh [Option 1] [Option 2]...."
	echo "Provides information about the local system"
	echo 
	echo "Running the script with no options provides this usage output"
	echo
	echo "  -a, --availdisk		display the available disk space on the system"
	echo "  -c, --cpudesc			display the CPU description of the system"
	echo "  -d, --domainname		display the system dns domain name"
	echo "  -i, --ipaddr			display the ip address(es) of the system"
	echo "  -m, --memory			display the memory installed in the system"
        echo "  -n, --hostname                display the system hostname"
	echo "  -o, --osname			display the operating system name for the system"
	echo "  -p, --printers		display the printers installed on the system"
	echo "  -s, --software		display the software installed on the system"
	echo "  -v, --version			display the operating system version for the system"
}

function error-message {
  echo "$@" >&2
}

# derives the available disk space for all disks beginning with /dev/sd*
function availablediskspace {
	echo
	echo "Disk Free Space:"
	declare -a disks
#	disknames=$(df -h | awk '/^["/dev/sd"]/' | awk '{print $1}')
	disknames=(`df -h | grep "/dev/sd" | awk '{print $1}'`)
        numberofdisks=${#disknames[@]}
        diskarrayindex=0
        while [ $diskarrayindex -lt $numberofdisks ] ; do
		currentdiskname=${disknames[$diskarrayindex]}
#               disks[$diskarrayindex]=$(df -h | awk '/^["/dev/sd"]/' | awk '{print $4}')
		disks[$diskarrayindex]=$(df -h | grep $currentdiskname | awk '{print $4}')
                freediskspace=${disks[$diskarrayindex]}
		echo "Disk $currentdiskname has $freediskspace of free disk space"
                diskarrayindex=$(( $diskarrayindex +1 ))
	done
}

# tests if the cpu variable contains text and outputs the appropriate comment or information
function cpudescription {
	echo
        if [ -z "$cpu" ]
		then echo "The system CPU description could not be discovered." 
                else echo "The system CPU is a(n):" $cpu
	fi
}

# tests if the domainname variable contains text and outputs the appropriate comment or information
function dnsdomainname {
	echo
	if [ -z "$domainname" ]
                then echo "This system does not have a domain name configured."
                else echo "The system domain name is:" $domainname
	fi
}

# derives the ip address of all interfaces
function ipaddress {
	echo
	echo "IP address of interface(s):"
	declare -a ips
        interfacenames=(`ifconfig | grep '^[a-zA-Z]' | awk '{print $1}'`)
        numberofinterfaces=${#interfacenames[@]}
        interfacearrayindex=0
        while [ $interfacearrayindex -lt $numberofinterfaces ] ; do
		currentinterfacename=${interfacenames[$interfacearrayindex]}
                ips[$interfacearrayindex]=$(ifconfig $currentinterfacename | grep 'inet addr' | sed -e 's/  *inet addr://'| sed -e 's/ .*//')
                currentinterfaceIPaddress=${ips[$interfacearrayindex]}
                echo "Interface $currentinterfacename: $currentinterfaceIPaddress"
                interfacearrayindex=$(( $interfacearrayindex +1 ))
	done
}

# tests if the memory variable contains text and outputs the appropriate comment or information
function memoryinstalled {
	echo
	if [ -z "$memory" ]
                then echo "The installed system memory could not be discovered."
                else echo "The installed system memory is:" $memory
	fi
}

# tests if the hostname variable contains text and outputs the appropriate comment or information
function nameofhost {
	echo
	if [ -z "$hostname" ]
                then echo "This system does not have a hostname configured."
                else echo "The system hostname is:" $hostname
        fi
}

# tests if the osname variable contains text and outputs the appropriate comment or information
function opersysname {
	echo
        if [ -z "$osname" ]
		then echo "The operating system name could not be discovered."
                else echo "The operating system name is:" $osname
        fi
}

# runs lpstat to display the installed printers, and send any error messages to a text file
function printersinstalled {
	# test if CUPS is installed, if not, echo instructions to user
	echo
	echo "Printers installed on the system:"
	lptstat 2>/dev/null || echo "You need to install CUPS. Please check /tmp/sysinfoerrors.txt for further details." >&2
	# if installed, outputs printers, if not, writes to error file
	lptstat -v 2>> $errorfile | awk '{print $3 " " $4}'
}

# runs dpkg to list the installed software
function softwareinstalled {
        echo 
	echo The system has the following software packages installed:
        dpkg --get-selections | more
}

# tests if the version variable contains text and outputs the appropriate comment or information
function versionofos {
	echo
        if [ -z $osversion ]
                then echo "The operating system version could not be discovered."
                else echo "The operating system version is:" $osversion
        fi
}


###########################
# Command line processing #
###########################


if  [ $# == 0 ]
then
	usage
	exit 0
fi

# test if cmd line args are valid before processing any


#while [ $cmdargnum -gt 0 ]; do
#        case "$1" in
#        -h|-a|-c|-d|-i|-m|-n|-o|-p|-s|-v )
#	[!-] )
#                echo "You dumbass, command line option '$1' is not valid."
#                echo "Run ./sysinfo.sh with -h or --help for usage information.">&2
#                exit 2
#		;;
#        esac
#	shift
#done

#echo "I've gone past..."

while [ $# -gt 0 ]; do
	case "$1" in
	-h|--help )
		usage
		exit 0
		;;
	-a|--availdisk )
		availablediskspace
		;;
	-c|--cpudesc )
		cpudescription
		;;
	-d|--domainname ) 
		dnsdomainname
		;;
	-i|--ipaddr )
		ipaddress
		;;
	-m|--memory )
		memoryinstalled
		;;
        -n|--name )
		nameofhost
                ;;
	-o|--osname )
		opersysname
		;;
	-p|--printers )
		printersinstalled
		;;
	-s|--software )
		softwareinstalled
		;;
        -v|--version )
                versionofos
                ;;
	* )
		echo "Command line option '$1' is not valid."
		echo "Run ./sysinfo.sh with -h or --help for usage information.">&2
		exit 2
		;;
	esac
	shift
done


#!/bin/bash
# This script displays requested system information. It accepts command line options for each item, or displays a usage menu if run 
# without any command line options.


#############
# Variables #
#############

errorfile=/tmp/sysinfoerrors.txt

cpu=$(head /proc/cpuinfo | grep "model name" | sed -e 's/model name//' -e 's/://')
domainname=$(dnsdomainname)
hostname=$(hostname)
memory=$(free -t -h | grep "Mem:" | awk '{print $2}')
osname=$(lsb_release -d | sed 's/Description://')
osversion=$(lsb_release -r | sed 's/Release://')

#############
# Functions #
#############

# Help message
function usage {
	clear
	echo "Usage: ./sysinfo.sh [Option 1] [Option 2]...."
	echo "Provides information about the local system"
	echo 
	echo "This script should be run as root"
	echo "Running the script with no options provides this usage output"
	echo
	echo "  -a, --all			display all options except installed software"
	echo "  -c, --cpu			display the CPU description of the system"
	echo "  -d, --domainname		display the system dns domain name"
	echo "  -f, --freediskspace     	display the available disk space on the system"
	echo "  -h, --help			display this usage menu"
	echo "  -i, --ipaddress		display the ip address(es) of the system (requires running as root)"
	echo "  -m, --memory			display the memory installed in the system"
        echo "  -n, --hostname		display the system hostname"
	echo "  -o, --osname			display the operating system name for the system"
	echo "  -p, --printers		display the printers installed on the system"
	echo "  -s, --software		display the software installed on the system"
	echo "  -v, --osversion		display the operating system version for the system"
	echo
}

# tests if the cpu variable contains text and outputs the appropriate comment or information
function cpudescription {
        if [ -z "$cpu" ]
		then echo "The system CPU description could not be discovered." 
                else echo "System CPU:" 
		echo $cpu
	fi
}

# tests if the domainname variable contains text and outputs the appropriate comment or information
function dnsdomainname {
	if [ -z "$domainname" ]
                then echo "This system does not have a domain name configured."
                else echo "System configured domain name:" 
		echo $domainname
	fi
}

# derives the available disk space for all disks beginning with /dev/sd*
function freespaceondisk {
        echo "Free Disk Space:"
        declare -a disks
        disknames=(`df -h | grep "/dev/sd" | awk '{print $1}'`)
        numberofdisks=${#disknames[@]}
        diskarrayindex=0
        while [ $diskarrayindex -lt $numberofdisks ] ; do
                currentdiskname=${disknames[$diskarrayindex]}
                disks[$diskarrayindex]=$(df -h | grep $currentdiskname | awk '{print $4}')
                freespace=${disks[$diskarrayindex]}
                echo "Disk $currentdiskname has $freespace of free disk space"
                diskarrayindex=$(( $diskarrayindex +1 ))
        done
}

# derives the ip address of all interfaces
function ipaddress {
	echo "IP address of interface(s):"
	declare -a ips
       	interfacenames=(`/sbin/ifconfig 2>> $errorfile | grep '^[a-zA-Z]' | awk '{print $1}'`)
       	numberofinterfaces=${#interfacenames[@]}
       	interfacearrayindex=0
	while [ $interfacearrayindex -lt $numberofinterfaces ] ; do
		currentinterfacename=${interfacenames[$interfacearrayindex]}
                ips[$interfacearrayindex]=$(/sbin/ifconfig $currentinterfacename | grep 'inet addr' | sed -e 's/  *inet addr://'| sed -e 's/ .*//')
               	currentinterfaceIPaddress=${ips[$interfacearrayindex]}
               	echo "Interface $currentinterfacename: $currentinterfaceIPaddress"
               	interfacearrayindex=$(( $interfacearrayindex +1 ))
	done
}

# tests if the memory variable contains text and outputs the appropriate comment or information
function memoryinstalled {
	if [ -z "$memory" ]
                then echo "The installed system memory could not be discovered."
                else echo "System installed memory:" 
		echo $memory
	fi
}

# tests if the hostname variable contains text and outputs the appropriate comment or information
function nameofhost {
	if [ -z "$hostname" ]
                then echo "This system does not have a hostname configured."
                else echo "System configured hostname:" 
		echo $hostname
        fi
}

# tests if the osname variable contains text and outputs the appropriate comment or information
function opersysname {
        if [ -z "$osname" ]
		then echo "The operating system name could not be discovered."
                else echo "Operating system:" 
		echo $osname
        fi
}

# runs lpstat to display the installed printers, and send any error messages to a text file
function printersinstalled {
	# test if CUPS is installed, if not, echo instructions to user
	lpstat &>/dev/null
	if [ $? -ne 0 ]
		then echo "Installed printers could not be displayed."
		echo "You might need to install CUPS. Please check /tmp/sysinfoerrors.txt for further details." >&2
		else echo "Installed printers:"
		# if installed, outputs printers, if not, writes to error file
		lpstat -v 2>> $errorfile | awk '{print $3 " " $4}'
	fi
}

# runs dpkg to list the installed software
function softwareinstalled {
	echo The system has the following software packages installed:
        dpkg -l | more
}

# tests if the version variable contains text and outputs the appropriate comment or information
function versionofos {
        if [ -z "$osversion" ]
                then echo "The operating system version could not be discovered."
                else echo "Operating system version:" 
		echo $osversion
        fi
}


###########################
# Command line processing #
###########################

# if no command arguements entered, display usage and exit

if  [ $# == 0 ]
then
	usage
	exit 0
fi

# test if cmd line arguementss are valid before processing any
# if valid, set parameter to yes for corresponding function
# if invalid, list bad arguement, display usage, and exit

while [ $# -gt 0 ]; do
	case "$1" in
	-h|--help )
		usage
		exit 0
		;;
	-a|--all )
		cpudescriptionvar=yes
		dnsdomainnamevar=yes
		freespaceondiskvar=yes
		ipaddressvar=yes
		memoryinstalledvar=yes
		nameofhostvar=yes
		opersysnamevar=yes
		printersinstalledvar=yes
		versionofosvar=yes
		;;
	-c|--cpu )
		cpudescriptionvar=yes
		;;
	-d|--domainname )
		dnsdomainnamevar=yes
                ;;
        -f|--freediskspace )
                freespaceondiskvar=yes
		;;
	-i|--ipaddress )
		ipaddressvar=yes
		;;
	-m|--memory )
		memoryinstalledvar=yes
		;;
        -n|--hostname )
		nameofhostvar=yes
                ;;
	-o|--osname )
		opersysnamevar=yes
		;;
	-p|--printers )
		printersinstalledvar=yes
		;;
	-s|--software )
		softwareinstalledvar=yes
		;;
        -v|--osversion )
                versionofosvar=yes
                ;;
	* )
		echo "Command line option '$1' is not valid."
		echo "Run ./sysinfo.sh with -h or --help for usage information.">&2
		exit 2
		;;
	esac
	shift
done

# Output header

echo
echo "+--------------------+"
echo "| System Information |"
echo "+--------------------+"
echo

# Process paramaters that are set to yes and run their corresponding function.

if [ "$cpudescriptionvar" == yes ] 
	then cpudescription
	echo
fi

if [ "$dnsdomainnamevar" == yes ]
	then dnsdomainname
	echo
fi

if [ "$freespaceondiskvar" == yes ]
	then freespaceondisk
	echo
fi

if [ "$ipaddressvar" == yes ]
	then ipaddress
	echo
fi

if [ "$memoryinstalledvar" == yes ]
	then memoryinstalled
	echo
fi

if [ "$nameofhostvar" == yes ]
	then nameofhost
	echo
fi

if [ "$opersysnamevar" == yes ]
	then opersysname
	echo
fi

if [ "$printersinstalledvar" == yes ]
	then printersinstalled
	echo
fi

if [ "$softwareinstalledvar" == yes ]
	then softwareinstalled
	echo
fi

if [ "$versionofosvar" == yes ]
	then versionofos
	echo
fi

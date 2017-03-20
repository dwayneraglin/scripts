#!/bin/bash
# This script prints out a welcome message
# It demonstrates using variables

export MYNAME="Dwayne Raglin"
mytitle="Supreme Overlord"
myhostname=`hostname`
# Although you can use ` to reflect a command in the var, you should use () as they are easier to read 
dayoftheweek=$(date +%A)

echo "Welcome to planet $myhostname, $mytitle $MYNAME!"
echo "Today is $dayoftheweek."


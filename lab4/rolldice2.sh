#!/bin/bash
# this script prompts the user for a count of dice and then rolls them

### Variables definitions
declare -i count
declare -i sides

## Functions
function showUsage {
  echo "Usage: $0 [-h] [-c #] [-s #]"
}
function errorMessage {
#  echo "***ERROR: $@" >&2
  prog=`basename $0`
  echo "${prog}: ${1:-Unknown Error - a moose bit my sister once...}" >&2

}

## Process the command line
# set some reasonable defaults
count=0
sides=0
while [ $# -gt 0 ]; do
	case "$1" in
	-h )
		showUsage
		exit 0
		;;
	-c )
    if [[ "$2" =~ ^[1-5]$ ]]; then
      count=$2
      shift
    else
      errorMessage "Number required for -c, from 1 to 5"
      exit 2
    fi
    ;;
  -s )
    if [[ "$2" =~ ^[1-9][0-9]*$ ]]; then
      if [ "$2" -ge 4 -a "$2" -le 20 ]; then
        sides=$2
        shift
      else
        errorMessage "Number required for -s, from 4 to 20"
        exit 2
      fi
    else
      errorMessage "Number required for -s, from 4 to 20"
      exit 2
    fi
    ;;
	* )
		showUsage
		errorMessage "Argument '$1' not recognized"
		exit 2
		;;
	esac
	shift
done
# we now have count and sides variables
# count and sides may have zero in them if the user didn't give us anything for them

## Get a roll count if there wasn't one on the command line
# get a valid roll count from the user
until [[ $count =~ ^[1-5]$ ]]; do
  read -p "How many dice shall I roll[1-5]? " count
# ignore empty count
  [ -n "$count" ] || continue
# specificied count must have the number 1-5 only
#  [[ $count =~ ^[1-5]$ ]] && break
done
# get a valid number of sides from the user
while [ "$sides" -lt 4 -o "$sides" -gt 20 ]; do
  read -p "How many sides should the dice have[4-20]? " sides
# ignore empty number
  [ -n "$sides" ] || continue
# specified sides must have the number 4-20 only
  if [[ "$sides" =~ ^[1-9][0-9]*$ ]]; then
    if [ "$sides" -ge 4 -a "$sides" -le 20 ]; then
      break
    fi
  fi

done

## Do the script's work
# do the dice roll as many times as the user asked for
for (( rolls=0 ; rolls < count ; rolls++ )); do
# roll the dice
  die1=$(($RANDOM % $sides +1))
  die2=$(($RANDOM % $sides +1))
  rolled=$(($die1 + $die2))
# show the roll results
  echo "Rolled $die1,$die2 for $rolled"
done

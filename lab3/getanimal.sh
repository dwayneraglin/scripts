#!/bin/bash
# This script demonstrates using arrays and getting user input

# unset variable removes the value of the variable
# unset animals
# unset colours

colours=(
	"red" 
	"green" 
	"blue" 
	"orange"
	)

declare -A animals
animals=(
	[red]="cardinal" 
	[green]="frog" 
	[blue]="lobster" 
	[orange]="fish"
	)

# animals[green]="snake" # This changes the green key value to snake
# animals[yellow]="butterfly" # This adds the array key yellow and sets the value to butterfly
numcolours=${#colours[@]}
read -p "Give me a number from 1 to $numcolours: " numrequested

# ask them over and over if they didn't give us something that looks like it might be valid
    while [[ ! "$numrequested" =~ ^[1-$numcolours]0*$ ]]; do
        read -p "Give me a number from 1 to $numcolours: " numrequested
    done

num=$((numrequested - 1))


colour=${colours[$num]}

animal=${animals[$colour]}

echo "Index $numrequested finds a $colour $animal"

# echo "Displays the associative array value of green"
# echo ${animals[green]}

# echo "Displays the value in key 1"
# echo ${colours[1]}

# echo "Displays all of the values in the keys"
# echo ${colours[@]}

# echo ${#colours[@]}

# echo ${#colours}



#!/bin/bash
# This script demonstrates using arrays and getting user input

# unset variable removes the value of the variable
# unset animals
# unset colours

# creates an array
colours=("red" "green" "blue" "orange" "pink")
# creates an associative array
declare -A animals
animals=([red]="cardinal" [green]="frog" [blue]="lobster" [orange]="fish" [pink]="flamingo")
# animals[green]="snake" # This changes the green key value to snake
# animals[yellow]="butterfly" # This adds the array key yellow and sets the value to butterfly
numcolours=${#colours[@]}
read -p "Give me a number from 1 to $numcolours: " numrequested
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



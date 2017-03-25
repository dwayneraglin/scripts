#!/bin/bash

#Create an array of colours, with at least 4 colours in it.
#Create an associative array of animals, where the keys are
#colours, and the values are animals who are that colour. Use
#the colours you put into the first array to show all the
# animals by their colour.

# Variables
###########
# create an array of colours with a fixed set of values
colours=(
    "red"
    "green"
    "blue"
    "yellow"
    "orange"
    "black and white"
    )

# create a hash of animals using their colour as they key for the animals
declare -A animals
animals=(
    ["red"]="cardinal"
    ["green"]="frog"
    ["blue"]="lobster"
    ["yellow"]="canary"
    ["orange"]="trumpapottamus"
    ["black and white"]="zebra"
    )

# this variable will hold each colour as we iterate over the colours array
colour=

# Main
######

# use a for loop to display all the related colour/animal pairs
for colour in "${colours[@]}" ; do
    echo "The $colour animal is a ${animals[$colour]}"
done

#!/bin/bash
# This script prompts the user for 2 numbers. It then performs the 5 different arithmetic funtions on the number.
# Finally, it displays the results in a user-friendly way.

read -p "Give me a number please: " num1
echo
echo "You gave me $num1"
echo
read -p "Give me a second number please: " num2
echo
echo "You gave me $num2"
echo
numsum=$((num1 + num2))
echo "The result of adding the 2 numbers is: $numsum"
echo
numdiff=$((num1 - num2))
echo "The result of subtracting the second number from the first number is: $numdiff"
echo
nummultiply=$((num1 * num2))
echo "The result of multiplying the 2 numbers is: $nummultiply"
echo
numdivide=$((num1 / num2))
echo "The result of dividing the first number by the second numer is: $numdivide"
echo
numremain=$((num1 % num2))
echo "The remainder from dividing the first number by the second number is: $numremain"
echo

#!/bin/bash
# This script prompts the user for 2 numbers. It then performs 5 different arithmetic functions on the number.
# Finally, it displays the results in a user-friendly format.

echo
read -p "Give me a number please: " num1
echo
echo "You gave me $num1"
echo
read -p "Give me a second number please: " num2
echo
echo "You gave me $num2"
echo
numsum=$((num1 + num2))
echo "The result of $num1 + $num2 is $numsum"
echo
numdiff=$((num1 - num2))
echo "The result of $num1 - $num2 is $numdiff"
echo
nummultiply=$((num1 * num2))
echo "The result of $num1 * $num2 is $nummultiply"
echo
numdivide=$((num1 / num2))
echo "The result of $num1 / $num2 is $numdivide"
echo
numremain=$((num1 % num2))
echo "The division remainder is $numremain"
echo

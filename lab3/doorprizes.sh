#!/bin/bash
#
# this script selects 3 door prizes from an array of possible prizes
# it then asks the user to pick one without the user knowing what they are
# it then tells the user what they have won

# create the prizes array
possibleprizes=("new car" "shopping spree" "trip to hawaii" "weekend in vegas" "extra help after class" "big high five")
prizecount=${#possibleprizes[@]}

# randomly select a prize for door 1
prizenum=$(($RANDOM % $prizecount))
# put each door prize into the mysteryprizes array at an index corresponding to their door
declare -a mysteryprize
mysteryprize[0]=${possibleprizes[$prizenum]}

# randomly select a prize for door 2
prizenum=$(($RANDOM %$prizecount))
# put the prize into the mysteryprize array for door 2 (second element)
mysteryprize[1]=${possibleprizes[$prizenum]}
# repick the prize for door 2 if the same random prize came up as door 1 has
while [ "${mysteryprize[1]}" == "${mysteryprize[0]}" ]; do
	prizenum=$(($RANDOM %$prizecount))
	mysteryprize[1]=${possibleprizes[$prizenum]}
done

# randomly select a prize for door 3
prizenum=$(($RANDOM %$prizecount))
mysteryprize[2]=${possibleprizes[$prizenum]}
# repick the prize for door 3 if the same random prize came up as door 1 or door 2 has
while [ "${mysteryprize[2]}" == "${mysteryprize[0]}" -o "${mysteryprize[2]}" == "${mysteryprize[1]}" ]; do
	prizenum=$(($RANDOM % $prizecount))
	mysteryprize[2]=${possibleprizes[$prizenum]}
done

cat <<EOF
We have 3 doors to choose from.
Pick a door to win the prize behind it!
1 - Door 1
2 - Door 2
3 - Door 3
EOF
until [[ "$pick" =~ ^[1-3]$ ]]; do
	read -p "Pick a mystery prize[1-3]: " pick
done

case $pick in
	1)
		echo "You won the ${mysteryprize[0]}!"
		echo "You missed out on the ${mysteryprize[1]}, and the ${mysteryprize[2]}."
		;;
	2)
		echo "You won the ${mysteryprize[1]}!"
		echo "You missed out on the ${mysteryprize[0]}, and the ${mysteryprize[2]}."
		;;
	3)
		echo "You won the ${mysteryprize[2]}!"
		echo "You missed out on the ${mysteryprize[1]}, and the ${mysteryprize[0]}."
		;;
	*)
		echo "Your pick of $pick is weird."
		;;
esac

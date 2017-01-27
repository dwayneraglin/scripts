#!/bin/bash
# This script displays how many regular files there are in the Pictures directory and how much disk space they use
# This script also shows the sizes and names of the 3 largest files in that directory.

echo -n "In the ~/Pictures directory, the number of files is "
find ~/Pictures -type f | wc -l

echo -n "These files use "
du -h ~/Pictures | awk '{print $1}'

echo "The three largest files are:"
echo "============================"
du -h ~/Pictures/* | sort -h | tail -3

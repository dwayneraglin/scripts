#!/bin/bash
# This script auto-updates a git repository and expect the commit comment on the command line

git add -A

# $1 grabs the first entry after the command, $@ grabs all entries after the command
# enclosing $1 in quotes ensures everything is grabbed, including spaces
git commit -m "$1"

git push


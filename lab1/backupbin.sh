#!/bin/bash
# This script backs up my personal bin to my personal backups directory

rsync -av ~/bin/ ~/backups

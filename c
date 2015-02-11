#! /bin/bash
#
# c.sh
# Copyright (C) 2015 damian <damian@damian-desktop>
#
# Distributed under terms of the MIT license.
#

#WARNING!!!! 
#This script works only with tmux vi-based keys mode 

LINE_NUMBER=2
if [ $# == 1 ];
then 
    LINE_NUMBER=$(($1+1))
fi
#echo $LINE_NUMBER 
tmux copy-mode \; send-keys $LINE_NUMBER k $ h Space ^ Enter 


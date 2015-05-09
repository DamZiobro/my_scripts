#! /bin/bash
#
# c.sh
# Copyright (C) 2015 damian <damian@damian-desktop>
#
# Distributed under terms of the MIT license.
#

#WARNING!!!! 
#This script works only with tmux vi-based keys mode 

LINE_NUMBER=1
if [ $# == 1 ];
then 
    LINE_NUMBER=$(($1))
fi
KEY=Space
while true;
do
    #echo $LINE_NUMBER 
    tmux copy-mode \; send-keys \? h t t p Enter 
    if [ $LINE_NUMBER -gt 1 ];
    then
        tmux send-keys $(($LINE_NUMBER-1)) n
    fi

    if [ "$KEY" != "\$" ];
    then
        tmux send-keys Space f $KEY h Enter
    else
        tmux send-keys Space $KEY h Enter
    fi

    COPIED_STRING=`tmux show-buffer -b 0`
    #echo "${COPIED_STRING}"
    if [[ $COPIED_STRING =~ http://.*[\.|/].*\" ]]
    then
        KEY=\" 
    elif [[ $COPIED_STRING =~ http://.*[\.|/].*\' ]]
    then
        KEY=\'
    elif [[ $COPIED_STRING =~ http://.*[\.|/].*\$ ]]
    then
        KEY=\$
    elif [ $COPIED_STRING == "h" ]
    then
        KEY=\$
    else 
        break
    fi
done 

echo $COPIED_STRING


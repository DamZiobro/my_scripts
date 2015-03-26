#! /bin/bash
#
# parallel_mode.sh
# Copyright (C) 2015 Damian Ziobro
#
# Distributed under terms of the MIT license.
#

SLEEP_TIME=10
SEQ_MAX=10000 
SEQ_TIME=$(($SLEEP_TIME * $SEQ_MAX))

function task(){
    printf "Task name %s \n" $i;
    sleep $SLEEP_TIME;
}

for i in `seq 1 $SEQ_MAX`; 
do
    #run new task in background  
    task $i &
done 

#wait for each job to finish
wait 

#variable SECONDS is global-available BASH variable containing 
#number of seconds which program already lasts 
echo "Program lasts $SECONDS secs in parallel mode (it would last $SEQ_TIME secs in sequence mode)"

#! /bin/bash
#
# schedule_apply_patches.sh
# script allows to commit patch queue as committing start right now with time intervals between commits
# Copyright (C) 2016 Damian Ziobro <damian@xmementoit.com>


LOGGER="clogger -t commit_scheduller"
GIT_REPO_DIR=${GIT_REPO_DIR:="$PWD"}
echo "GIT_REPO_DIR: $GIT_REPO_DIR" | $LOGGER
#exit

cd $GIT_REPO_DIR

GIT_BRANCH=$(git symbolic-ref --short HEAD)
PATCHES_DIR=$GIT_REPO_DIR/.git/patches/$GIT_BRANCH

#backup PATCHES_DIR
BACKUP_DIR=/tmp/patchesBackup_$((RANDOM%10000))
echo "PATCHES_DIR: $PATCHES_DIR" | $LOGGER
echo -e "Backing up files to dir: $BACKUP_DIR" | $LOGGER

cp -r $PATCHES_DIR $BACKUP_DIR

git qpush -a 

STEP=0
#getting patch name
for patch_file in $(cat $PATCHES_DIR/series); do 
  echo -e "===========================================================" | $LOGGER

  patch_path="${PATCHES_DIR}/${patch_file}"
  patch_message="$(cat $patch_path | head -n1)"
  echo -e "PATCH_NAME:$(basename $patch_path)" | $LOGGER
  echo -e "   - message: $patch_message" | $LOGGER
  
  schedule_file=/tmp/${patch_file}

  DATE_OF_COMMIT=$(git log --format="|%s| %ci" | grep "$patch_message" | cut -d '|' -f3 | cut -d' ' -f2-3)
  echo -e "   - DATE_OF_COMMIT: $DATE_OF_COMMIT" | $LOGGER
  #continue
  DATE_OF_COMMIT_EPOCH=$(date --date="$DATE_OF_COMMIT" +%s)
  if [ "$DATE_OF_COMMIT_EPOCH" == "" ]; then 
    echo -e "Cannot get commit name" | $LOGGER -l ERROR
    continue
  fi

  if [ $STEP -eq 0 ]; then 
    FIRST_COMMIT_EPOCH=$DATE_OF_COMMIT_EPOCH
  fi

  echo "DATE_OF_COMMIT_EPOCH: $DATE_OF_COMMIT_EPOCH" | $LOGGER
  echo "FIRST_COMMIT_EPOCH: $DATE_OF_COMMIT_EPOCH" | $LOGGER
  DIFF_COMMIT_NOW=$(($DATE_OF_COMMIT_EPOCH - $FIRST_COMMIT_EPOCH))
  DIFF_DAYS=$(($DIFF_COMMIT_NOW/(60*60*24)))
  DIFF_HOURS=$((($DIFF_COMMIT_NOW - $DIFF_DAYS*60*60*24)/(60*60)))
  DIFF_MINS=$((($DIFF_COMMIT_NOW - $DIFF_DAYS*60*60*24 - $DIFF_HOURS*60*60)/(60)))
  DIFF_SECS=$((($DIFF_COMMIT_NOW - $DIFF_DAYS*60*60*24 - $DIFF_HOURS*60*60 - $DIFF_MINS*60)))

  DIFF_MINS=$((DIFF_MINS+5))
  echo "DIFF_COMMIT_NOW: $DIFF_COMMIT_NOW (DAYS: $DIFF_DAYS; HOURS: $DIFF_HOURS; MINS: $DIFF_MINS; SECS: $DIFF_SECS)" | $LOGGER

  #always add 5 mins before apply first commit changes

  #additional randomness with seconds
  DIFF_SECS=$((DIFF_SECS+$(($RANDOM%30))))

  echo "cd $GIT_REPO_DIR" > $schedule_file | $LOGGER
  echo "sleep $DIFF_SECS" >> $schedule_file | $LOGGER
  echo "patch -p1 < $patch_path" >>  $schedule_file  | $LOGGER
  echo "git add ." >> $schedule_file | $LOGGER
  echo "git commit -m '$patch_message'" >> $schedule_file | $LOGGER

  echo -e "   - schedule file: $schedule_file \n\n$(cat $schedule_file)\n" | $LOGGER

  #DIFF_MINS=$(($RANDOM%5+1))
  #DIFF_HOURS=$STEP

  schedule_time=$(date --date "+$DIFF_DAYS day +$DIFF_HOURS hour +$DIFF_MINS min" "+%Y%m%d%H%M")
  echo -e "   - schedule time: ${schedule_time}" | $LOGGER

  echo -e "   - add schedule job using 'at' command: " | $LOGGER
  at -f $schedule_file -t $schedule_time | $LOGGER

  echo -e "   - scheduled jobs list: " | $LOGGER
  at -l | $LOGGER

  STEP=$((STEP+1))
  echo =e "===========================================================" | $LOGGER

  #break;
done

git qpop -a 

echo -e "Emptying $PATCHES_DIR/series file..." | $LOGGER
> $PATCHES_DIR/series

echo -e "DONE"




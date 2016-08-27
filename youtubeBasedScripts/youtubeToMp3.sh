#! /bin/bash
#
# youtubeToMp3.sh
# Copyright (C) 2016 damian <damian@damian-laptop>
#
# Distributed under terms of the MIT license.
#


INPUT_FILE=$1
LINKS_FILE=/tmp/links
OUTPUT_DIR=$PWD

if [ $# != 1 ]; then 
  echo -e "ERROR: wrong arguments number"
  echo -e "Usage: $0 file_with_list_of_songs"
  exit 2
fi

which youtube-dl &> /dev/null
if [ $? != 0 ]; then 
  echo "ERROR: youtube-dl is not installed"
  exit 1
fi

#Getting youtube links for files
cat $INPUT_FILE | while read LINE; do 
   echo -e "  - searching URL for song: $LINE"
  link=$(youtubeSearch.py $LINE | head -n1);
  LINE=$(echo $LINE | tr ' -' '_')
  echo "$LINE#$link" >> $LINKS_FILE
done

#Download youtube and save as mp3
cat $LINKS_FILE | while read LINE; do 
  TITLE=$(echo $LINE | cut -d'#' -f 1)
  LINK=$(echo $LINE | cut -d'#' -f 2)
  echo " - downloading mp3 for title: $TITLE"
  youtube-dl $LINK --extract-audio --audio-format mp3 --audio-quality 0 -o ${OUTPUT_DIR}/${TITLE}.mp3
done

for file in $(ls $OUTPUT_DIR); do
  echo " - converting mkv to mp3 for title: ${OUTPUT_DIR}/$file"
  ffmpeg -i ${OUTPUT_DIR}/$file -c:a libmp3lame ${OUTPUT_DIR}/${file}.mp3
  rm ${OUTPUT_DIR}/$file
done

rm $LINKS_FILE



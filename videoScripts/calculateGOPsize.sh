#! /bin/bash
#
# calculateGOPsize.sh

if [ -z $1 ]; then
  echo -e "Usage; $0 inputfile"
  exit 1
fi

ffprobe -show_frames $1 > /tmp/gop.txt 

GOP=0;

while read p; do
  if [ "$p" == "pict_type=P" -o "$p" == "pict_type=B" ]; then
    GOP=$((GOP+1))
  fi

  if [ "$p" == "pict_type=I" ]; then
    echo $GOP
    GOP=1;
  fi

done < /tmp/gop.txt


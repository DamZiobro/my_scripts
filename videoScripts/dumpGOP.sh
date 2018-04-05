#! /bin/bash
#
# calculateGOPsize.sh

if [ -z $1 ]; then
  echo -e "Usage; $0 inputfile"
  exit 1
fi

GOPsize=0;
GOP=""
GOPnr=1

function printGOP() {
      echo "GOP${GOPnr}: $GOP"
      echo "GOP${GOPnr} size: $GOPsize"
}

ffprobe -show_frames $1 2> /dev/null > /tmp/gop.txt 

while read p; do
  if [ "$p" == "pict_type=P" -o "$p" == "pict_type=B" ]; then
    GOPsize=$((GOPsize+1))
    frame=$(echo $p | cut -d= -f2 | tr -d '[:space:]')
    GOP="${GOP}${frame}"
  fi

  if [ "$p" == "pict_type=I" ]; then
    if [ $GOPsize -ne 0 ]; then
      printGOP
    fi
    GOPsize=1;
    GOP="I"
    GOPnr=$((GOPnr+1))
  fi

done < /tmp/gop.txt

printGOP

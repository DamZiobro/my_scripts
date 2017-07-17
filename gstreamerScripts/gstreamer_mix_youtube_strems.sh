#! /bin/bash
#
# Script mixes 2 youtube live chaannels into 1 new live stream: 2 youtube inputs - 1 for video + 1 for audio
# Author: Damian Ziobro <damian@xmementoit.com>

YOUTUBE_URL='https://www.youtube.com/watch?v=y60wDzZt8yg'
echo -e "Getting youtube playable URL for video input from this URL: $YOUTUBE_URL"
YOUTUBE_BEST_FORMAT=$(youtube-dl --list-formats $YOUTUBE_URL | tail -n 1 | cut -d' ' -f 1)
YOUTUBE_PLAYABLE_HLS_URL="$(youtube-dl -f $YOUTUBE_BEST_FORMAT -g $YOUTUBE_URL)"

YOUTUBE_AUDIO_URL='https://www.youtube.com/watch?v=AL-5nP9efIU'
echo -e "Getting youtube playable URL for audio input from this URL: $YOUTUBE_AUDIO_URL"
YOUTUBE_AUDIO_BEST_FORMAT=$(youtube-dl --list-formats $YOUTUBE_AUDIO_URL | tail -n 1 | cut -d' ' -f 1)
YOUTUBE_AUDIO_PLAYABLE_HLS_URL="$(youtube-dl -f $YOUTUBE_AUDIO_BEST_FORMAT -g $YOUTUBE_AUDIO_URL)"


GST_DEBUG=*:3,rtmpsink:5 gst-launch-1.0 \
    souphttpsrc is-live=1 location="$YOUTUBE_PLAYABLE_HLS_URL" ! hlsdemux ! tsdemux name=demux demux. ! "video/x-h264,framerate=24/1" ! queue ! h264parse ! queue ! mux. \
    souphttpsrc is-live=1 location="$YOUTUBE_AUDIO_PLAYABLE_HLS_URL" ! queue ! qtdemux ! "audio/mpeg" ! mux. \
    flvmux streamable=1 name=mux  \
    ! rtmpsink location="rtmp://x.rtmp.youtube.com/x/live2/YOUR_YOUTUBE_ID app=live2"
    #! filesink location="out.flv"


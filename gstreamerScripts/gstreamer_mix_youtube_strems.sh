#! /bin/bash
#
# gst_stream_live.sh

## PIPELINE REQUIRES node-youtubeStreamer for work (https://github.com/licson0729/node-YouTubeStreamer)
#GST_DEBUG=*:2,rtmpsink:6 gst-launch-1.0 \
    #souphttpsrc is-live=1 location="http://localhost:8000/?id=NzD2UdQl5Gc" ! queue2 ! qtdemux ! "video/x-h264" ! mux. \
    #audiotestsrc is-live=1 wave=12 ! faac ! queue ! mux. \
    #flvmux streamable=1 name=mux  \
    #! rtmpsink location="rtmp://x.rtmp.youtube.com/x/live2/e1fb-2ug3-2ey5-54x6 app=live2" ##! filesink location="out.flv" 
## PIPELINE REQUIRES node-youtubeStreamer for work (https://github.com/licson0729/node-YouTubeStreamer)
#GST_DEBUG=*:2,rtmpsink:6 gst-launch-1.0 \
    #souphttpsrc is-live=1 location="http://localhost:8000/?id=NzD2UdQl5Gc" ! queue2 ! qtdemux ! "video/x-h264" ! mux. \
    #souphttpsrc is-live=1 location="http://localhost:8000/?id=PxnKVwgWvYE" ! queue ! qtdemux ! "audio/mpeg" ! mux. \
    #flvmux streamable=1 name=mux  \
    #! rtmpsink location="rtmp://x.rtmp.youtube.com/x/live2/e1fb-2ug3-2ey5-54x6 app=live2"
    ##! filesink location="out.flv"



## Streaming as expected with transcoding 
## PIPELINE REQUIRES node-youtubeStreamer for work (https://github.com/licson0729/node-YouTubeStreamer)
#GST_DEBUG=*:3,rtmpsink:5 gst-launch-1.0 \
    #souphttpsrc do-timestamp=true is-live=1 location="$(youtube-dl -f 94 -g 'https://www.youtube.com/watch?v=y60wDzZt8yg')" ! hlsdemux ! tsdemux name=demux demux. ! "video/x-h264" ! queue ! h264parse ! avdec_h264 ! videorate ! videoconvert ! x264enc ! h264parse ! queue ! mux. \
    #audiotestsrc is-live=1 wave=12 ! faac ! queue ! mux. \
    #flvmux streamable=1 name=mux  \
    #! rtmpsink location="rtmp://x.rtmp.youtube.com/x/live2/e1fb-2ug3-2ey5-54x6 app=live2"
    ##! filesink location="out.flv"


## Streaming as expected with transcoding 
## PIPELINE REQUIRES node-youtubeStreamer for work (https://github.com/licson0729/node-YouTubeStreamer)
#YOUTUBE_URL='https://www.youtube.com/watch?v=y60wDzZt8yg'
#echo -e "Getting youtube playable URL for video input from this URL: $YOUTUBE_URL"
#YOUTUBE_BEST_FORMAT=$(youtube-dl --list-formats $YOUTUBE_URL | tail -n 1 | cut -d' ' -f 1)
#YOUTUBE_PLAYABLE_HLS_URL="$(youtube-dl -f $YOUTUBE_BEST_FORMAT -g $YOUTUBE_URL)"

#YOUTUBE_AUDIO_URL='https://www.youtube.com/watch?v=AL-5nP9efIU'
#echo -e "Getting youtube playable URL for audio input from this URL: $YOUTUBE_AUDIO_URL"
#YOUTUBE_AUDIO_BEST_FORMAT=$(youtube-dl --list-formats $YOUTUBE_AUDIO_URL | tail -n 1 | cut -d' ' -f 1)
#YOUTUBE_AUDIO_PLAYABLE_HLS_URL="$(youtube-dl -f $YOUTUBE_AUDIO_BEST_FORMAT -g $YOUTUBE_AUDIO_URL)"

#GST_DEBUG=*:3,rtmpsink:5 gst-launch-1.0 \
    #souphttpsrc do-timestamp=true is-live=1 location="$YOUTUBE_PLAYABLE_HLS_URL" ! hlsdemux ! tsdemux name=demux demux. ! "video/x-h264" ! queue ! h264parse ! avdec_h264 ! videorate ! videoconvert ! x264enc ! h264parse ! queue ! mux. \
    #souphttpsrc do-timestamp=true is-live=1 location="$YOUTUBE_AUDIO_PLAYABLE_HLS_URL" ! queue ! qtdemux ! "audio/mpeg" ! mux. \
    #flvmux streamable=1 name=mux  \
    #! rtmpsink location="rtmp://x.rtmp.youtube.com/x/live2/e1fb-2ug3-2ey5-54x6 app=live2"
    ##! filesink location="out.flv"


# Streaming as expected (2 youtube inputs - 1 for video + 1 for audio) 
# PIPELINE REQUIRES node-youtubeStreamer for work (https://github.com/licson0729/node-YouTubeStreamer)
YOUTUBE_URL='https://www.youtube.com/watch?v=y60wDzZt8yg'
echo -e "Getting youtube playable URL for video input from this URL: $YOUTUBE_URL"
YOUTUBE_BEST_FORMAT=$(youtube-dl --list-formats $YOUTUBE_URL | tail -n 1 | cut -d' ' -f 1)
YOUTUBE_PLAYABLE_HLS_URL="$(youtube-dl -f $YOUTUBE_BEST_FORMAT -g $YOUTUBE_URL)"
#YOUTUBE_PLAYABLE_HLS_URL="http://208.43.120.148:5000/live/116/116.m3u8"

YOUTUBE_AUDIO_URL='https://www.youtube.com/watch?v=AL-5nP9efIU'
echo -e "Getting youtube playable URL for audio input from this URL: $YOUTUBE_AUDIO_URL"
YOUTUBE_AUDIO_BEST_FORMAT=$(youtube-dl --list-formats $YOUTUBE_AUDIO_URL | tail -n 1 | cut -d' ' -f 1)
YOUTUBE_AUDIO_PLAYABLE_HLS_URL="$(youtube-dl -f $YOUTUBE_AUDIO_BEST_FORMAT -g $YOUTUBE_AUDIO_URL)"


GST_DEBUG=*:3,rtmpsink:5 gst-launch-1.0 \
    souphttpsrc is-live=1 location="$YOUTUBE_PLAYABLE_HLS_URL" ! hlsdemux ! tsdemux name=demux demux. ! "video/x-h264,framerate=24/1" ! queue ! h264parse ! queue ! mux. \
    souphttpsrc is-live=1 location="$YOUTUBE_AUDIO_PLAYABLE_HLS_URL" ! queue ! qtdemux ! "audio/mpeg" ! mux. \
    flvmux streamable=1 name=mux  \
    ! rtmpsink location="rtmp://x.rtmp.youtube.com/x/live2/e1fb-2ug3-2ey5-54x6 app=live2"
    #! filesink location="out.flv"


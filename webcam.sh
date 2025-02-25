#!/bin/bash
#
# Installed in /home/pi/webcam.sh
#

YOUTUBE_URL="rtmp://x.rtmp.youtube.com/live2" # Server URL
KEY="abc80-12-3-demo-example-key"

IP=192.168.1.100
RTSP_PORT=7441
QUIET='-loglevel panic'

# Uncomment the empty QUIET variable below to see debugging output
QUIET=''

ffmpeg ${QUIET} -hide_banner \
	-ar 11025 -acodec pcm_s16le -f s16le -ac 2 -channel_layout 2.1 -i /dev/zero \
	-thread_queue_size 4096 \
	-i rtsps://${IP}:${RTSP_PORT}/jmrFQMwDErDw8K0s?enableSrtp \
	-rtsp_transport tcp -ss 2 -c:v copy -shortest -f flv "${YOUTUBE_URL}/${KEY}"

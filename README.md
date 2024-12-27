# weather-webcam-tools
All of the scripts and instructions for webcam relay to YouTube and Ambient Weather conversion to MQTT

# Overview
There is a raspberry pi that runs software to perform the following functions:
*    Convert an RTSP stream using ffmpeg for delivery to YouTube's live streaming end point.
*    Start the service at boot and restart automatically if necessary.
*    Monitor the webstream and send an email if it appears to be down.
*    Take a snapshot still image from the RTSP web stream, retrieve and publish the snapshot for use by ambientweather.net.

# Video

These instructions do not cover how one sets up a live stream at
https://studio.youtube.com, a suggestion is to create a scheduled live
stream that starts as soon as data is streamed.

On the raspberry pi is a bash script that is run as a service at boot
time that reads the RTSP stream from the local camera and outputs that
stream to a YouTube streaming end point. The audio portion of the
video is removed to reduce bandwidth, your requirements may be
different.

## webcam.sh
```
#!/bin/bash
#
# Installed in /home/pi/webcam.sh
#

YOUTUBE_URL="rtmp://x.rtmp.youtube.com/live2" # Server URL
KEY="r9jh-prb8-78s4-demo-3m4s"   # This is not a real key, generate your own

# Internal webcam IP address and port, probably should have
# included the stream key here as well.
IP=10.10.2.65
RTSP_PORT=7441
QUIET='-loglevel panic'

# Uncomment the empty QUIET variable below to see debugging output
QUIET=''

ffmpeg ${QUIET} -hide_banner \
	-ar 11025 -acodec pcm_s16le -f s16le -ac 2 -channel_layout 2.1 -i /dev/zero \
	-thread_queue_size 4096 \
	-i rtsps://10.10.2.1:7441/not-a-real-rtsp-stream-key-leSrtp \
	-rtsp_transport tcp -ss 2 -c:v copy -shortest -f flv "$YOUTUBE_URL/$KEY"
```

## webcam.service file in /lib/systemd/system
```
#
# Installed in /lib/systemd/system/webcam.service
#
[Unit]
Description=Webcam RTSP to Youtube transcoder
After=network.service

[Service]
User=admin
Type=simple
ExecStart=/bin/bash /home/admin/webcam.sh
Restart=always
RestartSec=90
[Install]
WantedBy=multi-user.target
```
As root, do the following:
* Install the file in /lib/systemd/system/
* systemctl daemon-reload
* systemctl enable webcam
* service webcam start
* service webcam status

## Monitor the stream

Sometimes the ffmpeg streamer will continue to stream successfully to
the YouTube live endpoint, but the YouTube live stream itself has
expired. A python script named webcam-monitor.py was created to
monitor the output of the stream and report by email if a failure was
detected using the streamlink program that can be installed via apt
get. There may be better ways to accomplish this task using the Google
YouTube API.

### Crontab entry for monitor
```
*/10 * * * * /home/admin/webcam-monitor.py
```

## Take a snapshot of the RTSP stream
Save this file as snapshot.sh
```
#!/bin/bash
cd $HOME
/usr/bin/ffmpeg -loglevel quiet -y -i 'rtsps://10.10.2.1:7441/this-is-a-demo-key?enableSrtp' -vframes 1  bayview.jpg
```

### Crontab entry for snapshot
```
*/2 * * * * /home/admin/snapshot.sh
```

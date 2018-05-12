#!/bin/bash
# echo $1 $2
# nohup ffmpeg -re -i "$1" -c:v libx264 -b:v 1.5M -preset veryfast -c:a libfdk_aac -b:a 128k -f flv "rtmp://rtmp-api.facebook.com:80/rtmp/$2" > /dev/null 2>&1 &

echo $1
link=$(youtube-dl -f best --get-url $1)
if [ -z $3 ]
then
    nohup ffmpeg -re -i "$link" -c:v libx264 -preset fast -c:a copy -f flv "rtmp://rtmp-api.facebook.com:80/rtmp/1660942397315179?s_ps=1&a=AThi4u_tRKmxtyup" > /dev/null 2>&1 &
else
    echo "Logo: $3"
     nohup ffmpeg -re -i "$1" -i "$3" -filter_complex overlay=W-w-5:H-h-5 -c:v libx264 -preset fast -c:a copy -f flv "rtmp://rtmp-api.facebook.com:80/rtmp/$2" > /dev/null 2>&1 &
fi

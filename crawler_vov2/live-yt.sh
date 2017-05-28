#!/bin/bash

if [ $# -eq 3 ]
then
	echo $1 $2 $3
	ffmpeg -re -stream_loop $1 -f concat -i $2  -vcodec libx264 -preset veryfast -maxrate 3000k -bufsize 6000k -pix_fmt yuv420p -g 50 -c:a aac -b:a 160k -ac 2 -ar 44100 -f flv "rtmp://a.rtmp.youtube.com/live2/$3" > /dev/null 2>&1 &
	case $? in
		0)
			echo "OK"
			;;
		*)
			echo "Loi."
			;;
	esac
else
	echo "Su dung: $0 <so-lan-phat> <playlist> <key-youtube>"
fi 
#!/bin/bash
#cd cotich/

if [ ! -e sub.png ]
then
	wget https://github.com/hoangdh/blog_backup/blob/master/crawler_vov2/sub.png?raw=true
	mv 'sub.png?raw=true' sub.png
fi

name=`ls . | egrep '*.mp3'`

for x in $name
do
    x=`basename $x .mp3`
    echo $x
   # ffmpeg -loop 1 -i $x.jpg -i $x.mp3 -c:v libx264 -s 1280x720 -preset veryfast -c:a aac -strict experimental -b:a 192k -shortest $x.mp4
   ffmpeg -i $x.jpg -vf scale=320:240 -s 1280x720 $x.png
   #rm -rf $x.jpg
   ffmpeg -loop 1 -i $x.png -i $x.mp3 -i sub.png -filter_complex "pad=height=ih+40:color=#71cbf4,overlay=(main_w-overlay_w)/2:main_h-overlay_h"  -c:v libx264 -s 1280x720 -preset veryfast  -c:a aac -strict experimental -b:a 192k -shortest $x.mp4
done 
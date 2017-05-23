#!/bin/bash

name=`ls . | egrep '*.mp3'`

for x in $name
do
    x=`basename $x .mp3`
   # echo $x
	
	ls $x.mp4
	if [ "$?" == "2" ]
		then
		echo "File $x chua duoc render." 
		echo "MP4: $x" >> /opt/crawler/miss_file.txt
		ffmpeg -loop 1 -i default.jpg -i $x.mp3 -i sub.png -filter_complex "pad=height=ih+40:color=#71cbf4,overlay=(main_w-overlay_w)/2:main_h-overlay_h"  -c:v libx264 -s 1280x720 -preset veryfast  -c:a aac -strict experimental -b:a 192k -shortest $x.mp4		
	fi	
done 
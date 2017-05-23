#!/bin/bash

if [ ! -e sub.png ]
then
	wget https://github.com/hoangdh/blog_backup/blob/master/crawler_vov2/sub.png?raw=true
	mv 'sub.png?raw=true' sub.png
fi

if [ ! -e default.png ]
then
	wget https://raw.githubusercontent.com/hoangdh/blog_backup/master/crawler_vov2/default.jpg
fi

name=`ls . | egrep '*.mp3'`

for x in $name
do
    x=`basename $x .mp3`
    echo $x
	# Lay title
	title=`cat $x.txt | head -n 1 | tr ':' ' '`
	### Sua thumbnail
     ffmpeg -i $x.jpg -s 400x300 -vf scale=400:300 $x-thumb.png
    ### Chen text vao background
	ffmpeg -i background.jpg -vf "drawtext="fontfile=/opt/ARIAL.TTF": text='$title': fontcolor=white: fontsize=30: box=1: boxcolor=black@0.5: boxborderw=5: x=40: y=20" $x.png
	###
	ffmpeg -loop 1 -i $x.png -i $x.mp3 -i $x-thumb.png -filter_complex "overlay=75:75"  -c:v libx264 -aspect 16:9 -s 1280x720 -preset veryfast  -c:a aac -strict experimental -b:a 192k -shortest $x.mp4
done 

#!/bin/bash

if [ ! -e /opt/KINKIE.TTF ]
then
	wget https://raw.githubusercontent.com/hoangdh/blog_backup/master/crawler_vov2/KINKIE.TTF -O /opt/KINKIE.TTF
fi
year=`date +%Y`

LIST=`ls *.mp4`

for x in $LIST
do
	ffmpeg -i $x -vf "drawtext="fontfile=/opt/KINKIE.TTF": text='AsianTrailerFilms': fontcolor=white: fontsize=29: x=40: y=20" -c:v libx264 -preset veryfast -s 1280x720 -metadata copyright="Copyright $year AsianTrailerFilms." -metadata year="$year" -metadata title="$x" $x-done.mp4
done

#!/bin/bash
###########
#
# 1. Tai 1 file background
# 2. Xoa file loi
# 3. Render kem tieu de va thumb
#
#
###########

if [ ! -e background.png ]
then
	wget https://raw.githubusercontent.com/hoangdh/blog_backup/master/crawler_vov2/default-eva.png
	mv default-eva.png background.png
fi

if [ ! -e /opt/ARIAL.TTF ]
then
	wget https://raw.githubusercontent.com/hoangdh/blog_backup/master/crawler_vov2/ARIAL.TTF -O /opt/ARIAL.TTF
fi
# Xoa nhung file loi
find . -type f -empty | xargs rm

# Liet ke cac file co trong thu muc
name=`ls . | egrep '*.mp3'`

for x in $name
do
	x=`basename $x .mp3`
    echo $x
	
	# Lay title
	title=`cat $x.txt | head -n 1 | tr ':' ' '`
	
    ### Chen text vao background
	ffmpeg -i background.png -vf "drawtext="fontfile=/opt/ARIAL.TTF": text='$title': fontcolor=white: fontsize=30: box=1: boxcolor=black@0.5: boxborderw=5: x=40: y=220" $x.png
	
	### Sua thumbnail
	ls $x.jpg
	if [ "$?" == "2" ]
	then
		ffmpeg -loop 1 -i $x.png -i $x.mp3 -c:v libx264 -aspect 16:9 -s 1280x720 -preset veryfast  -c:a aac -strict experimental -b:a 192k -shortest $x.mp4
	else
		ffmpeg -i $x.jpg -s 400x300 -vf scale=400:300 $x-thumb.png
		### Render video 720p
		ffmpeg -loop 1 -i $x.png -i $x.mp3 -i $x-thumb.png -filter_complex "overlay=40:275"  -c:v libx264 -aspect 16:9 -s 1280x720 -preset veryfast  -c:a aac -strict experimental -b:a 192k -shortest /opt/mach-nho-chi-em/$x.mp4
	fi
done 

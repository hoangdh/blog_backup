#!/bin/bash

mkdir -p /opt/story-`date +%Y-%m-%d`

for x in `seq 1 67`
do
	wget http://www.storynory.com/category/stories/page/$x/ -O- |  grep -Po '(?<=href=")[^"]*' | grep -Ev "category|php|wp-*" | grep storynory.com | sort -u >> /opt/story-`date +%Y-%m-%d`/list.txt
	sleep 1
done

list=`cat /opt/story-$(date +%Y-%m-%d)/list.txt | sort -u`
for x in $list
do
	wget $x -O abc.html 2>&1 > /dev/null
	name=`echo $x | awk -F '/' '{print $4}'`
	mp3=`cat abc.html | awk '/mp3/ {print $3}' | grep "mp3" | cut -d "\"" -f2 | grep https | sort -u`
	img=`cat abc.html | awk '/og:image/ {print $3}' | cut -d "\"" -f2 | sort -u | grep -Ev "[0-9]$"`
	
	echo -e "$mp3" > mp3.txt
	echo -e "$img" > img.txt
	
	wget -i mp3.txt -O /opt/story-$(date +%Y-%m-%d)/$name.mp3
	wget -i img.txt -O /opt/story-$(date +%Y-%m-%d)/$name.jpg
	
	rm -rf abc.html mp3.txt img.txt
done

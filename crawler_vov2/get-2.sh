#!/bin/bash
### Su dung link mobile: http://vov2.vov.vn/kich-truyen-thanh-cmobile60.aspx
PAGE="$1"
INDEX=`echo $PAGE | awk -F '-cmobile*' {'print $1'} | awk -F "//" {'print $2}' | awk -F / {'print $2'}`
PAGES=`curl $PAGE | grep -Po '(?<=href=")[^"]*' | egrep "/$INDEX/*-cmobile*" | sort -u`

for x in $PAGES
do
	curl $x | grep -Po '(?<=href=")[^"]*' | egrep "/$INDEX/" | sort -u >> $INDEX.txt
	sed -i 's/c43/cmobile43/g' $INDEX.txt
done

link=`cat $INDEX.txt`
FOLDER_CUR=`pwd`
mkdir -p $FOLDER_CUR/$INDEX

for y in $link
do
	name=`echo $y | awk -F '/' {'print $3'} | awk -F '.' {'print $1'}`
	fmp3=`curl http://vov2.vov.vn$y | grep -e 'file: \"mp3' |  grep -o "Attachments[^ ]*.*$" | awk -F '\"' '{print $1}'`
	fjpg=`curl http://vov2.vov.vn$y | grep -e '.jpg' |  grep -o "http[^ ]*.*$" | awk -F '\"' '{print $1}' | grep -e "UploadImages/vov2/" | awk -F '\?' '{print $1}' | sort -u | head -n 1`
	wget "http://media.vov2.vn/vov2/$fmp3" -O $FOLDER_CUR/$INDEX/$name.mp3
	wget "$fjpg" -O $FOLDER_CUR/$INDEX/$name.jpg
done
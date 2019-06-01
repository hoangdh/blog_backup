#!/bin/bash
### Su dung link mobile: http://vov2.vov.vn/kich-truyen-thanh-c60.aspx
#Update: 1/6/2019
PAGE="$1"

INDEX=`echo $PAGE | awk -F '-c[0-9]' {'print $1'} | awk -F "//" {'print $2}' | awk -F / {'print $2'}`
ID=$(echo $PAGE | grep -Eo '(c)[0-9]+' | grep -Eo '[0-9]+')

for x in {1..$2}
do
	echo "Crawling page: $x"
	curl -s $(echo $PAGE | sed "s/c${ID}/cmobile${ID}-p${x}/g") | grep -Po '(?<=href=")[^"]*' | egrep "/$INDEX/" | sort -u >> $INDEX.txt
done

download(){
INDEX=$1
link=`cat $INDEX.txt`
FOLDER_CUR=`pwd`
mkdir -p $FOLDER_CUR/$INDEX

for y in $link
do
	name=`echo $y | awk -F '/' {'print $3'} | awk -F '.' {'print $1'}`
	echo "Downloading: $name"
	title=`curl -s http://vov2.vov.vn$y | grep -e "Ondemand_title\"" | sed 's|</b>|-|g' | sed 's|<[^>]*>||g' | tr -d "\t"`
	des=`curl -s http://vov2.vov.vn$y | grep -e "Ondemand_title2" | sed 's|</b>|-|g' | sed 's|<[^>]*>||g'`
	fjpg=`curl -s http://vov2.vov.vn$y | grep -e '.jpg' |  grep -o "http[^ ]*.*$" | awk -F '\"' '{print $1}' | grep -e "UploadImages/vov2/" | awk -F '\?' '{print $1}' | sort -u | head -n 1`
	y=`sed 's/cmobile/c/' <<< $y`
	fmp3=`curl -s http://vov2.vov.vn$y | awk '/plcAll_Ondemand_hdFile/ {print $5}' | awk -F "=" '{print $2}' | tr -d '"'`
	wget -q "$fmp3" -O $FOLDER_CUR/$INDEX/$name.mp3
	wget -q "$fjpg" -O $FOLDER_CUR/$INDEX/$name.jpg
	echo -e "$title\n$des" > $FOLDER_CUR/$INDEX/$name.txt
done 
}

download $INDEX
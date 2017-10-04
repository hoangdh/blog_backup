#!/bin/bash

# 1. Vao page, lay tat ca cac page 1 - 100
# 2. Lay link tung bai viet
#
#
#
#
#
#
#


PAGE="http://vov2.vn/ke-chuyen-va-hat-ru-cmobile43.aspx"
INDEX=`echo $PAGE | awk -F '-cmobile*' {'print $1'} | awk -F "//" {'print $2}' | awk -F / {'print $2'}`

for x in {1..100}
do
	curl http://vov2.vn/ke-chuyen-va-hat-ru-cmobile43-p$x.aspx | grep -Po '(?<=href=")[^"]*' | egrep "/$INDEX/" | sort -u >> $INDEX.txt
	sleep 5
done

link=`cat $INDEX.txt`
FOLDER_CUR=`pwd`
mkdir -p $FOLDER_CUR/$INDEX

for y in $link
do
	name=`echo $y | awk -F '/' {'print $3'} | awk -F '.' {'print $1'}`
	title=`curl http://vov2.vov.vn$y | awk 'BEGIN{IGNORECASE=1;FS="<title>|</title>";RS=EOF} {print $2}'`
	des=`curl http://vov2.vov.vn$y | grep -e "Ondemand_title2" | sed 's|</b>|-|g' | sed 's|<[^>]*>||g'`
	fmp3=`curl http://vov2.vov.vn$y | grep -e 'id="plcAll_Ondemand_hdFile' | awk -F 'value=\"' {'print $3'} | awk -F \" {'print $1'}`
	fjpg=`curl http://vov2.vov.vn$y | grep -e '.jpg' |  grep -o "http[^ ]*.*$" | awk -F '\"' '{print $1}' | grep -e "UploadImages/vov2/" | awk -F '\?' '{print $1}' | sort -u | head -n 1`
	echo -e "$name \n$title \n$des \n$fjpg $fmp3"
	#wget "http://media.vov2.vn/vov2/$fmp3" -O $FOLDER_CUR/$INDEX/$name.mp3
	#wget "$fjpg" -O $FOLDER_CUR/$INDEX/$name.jpg
	#echo -e "Title: $title\nDes.: $des\n=========" > $FOLDER_CUR/$INDEX/$name.txt
done
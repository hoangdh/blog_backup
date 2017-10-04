#!/bin/bash

# 1. Vao page, lay tat ca cac page 1 - 100
# 2. Lay link tung bai viet
# 3. 23/9/2017 Fix link mp3
#



PAGE="http://vov2.vn/ke-chuyen-va-hat-ru-cmobile43.aspx"
INDEX=`echo $PAGE | awk -F '-cmobile*' {'print $1'} | awk -F "//" {'print $2}' | awk -F / {'print $2'}`
# PREFIX=`echo $PAGE | cut -d . -f1,2`
# for x in {1..100}
# do
	# curl $PREFIX-p$x.aspx | grep -Po '(?<=href=")[^"]*' | egrep "/$INDEX/" | sort -u >> $INDEX.txt
	# sleep 5
# done

link=`cat $INDEX.txt | sort -u`
FOLDER_CUR=`pwd`
mkdir -p $FOLDER_CUR/$INDEX

for y in $link
do
	wget http://vov2.vov.vn$y -O data.h2
	name=`echo $y | awk -F '/' {'print $3'} | awk -F '.' {'print $1'}`
	title=`cat data.h2 | awk 'BEGIN{IGNORECASE=1;FS="<title>|</title>";RS=EOF} {print $2}'`
	des=`cat data.h2 | grep -e "Ondemand_title2" | sed 's|</b>|-|g' | sed 's|<[^>]*>||g'`
	# fmp3=`cat data.h2 | grep -e 'id="plcAll_Ondemand_hdFile' | awk -F 'value=\"' {'print $3'} | awk -F \" {'print $1'}`
	fmp3=$(cat data.h2 | grep -wE "id=\"plcAll_Ondemand_hdFile\"" | awk -F 'value=\"' {'print $2'} |  awk -F \" {'print $1'})
	fjpg=`cat data.h2 | grep -e '.jpg' |  grep -o "http[^ ]*.*$" | awk -F '\"' '{print $1}' | grep -e "UploadImages/vov2/" | awk -F '\?' '{print $1}' | sort -u | head -n 1`
	# echo -e "$name \n$title \n$des \n$fjpg \n$fmp3" >> tmp.hoang
	rm -rf data.h2
	wget "$fmp3" -O $FOLDER_CUR/$INDEX/$name.mp3
	wget "$fjpg" -O $FOLDER_CUR/$INDEX/$name.jpg
	echo -e "Title: $title\nDes.: $des\n=========" > $FOLDER_CUR/$INDEX/$name.txt
done
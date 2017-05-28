#!/bin/bash

list=`ls *.txt`

FOLDER_CUR=`pwd`
mkdir -p $FOLDER_CUR/hat-ru
for x in $list
do
	title=`cat $x | head -n 1`
	des=`cat $x | head -n 2`
	echo -e "KỂ CHUYỆN VÀ HÁT RU CHO BÉ: $title

Chuyên mục: Kể chuyện và hát ru cho bé - VOV2

TÓM TẮT: $des

Nguồn: 
Chuyên mục: Kể chuyện và hát ru cho bé - VOV2.VOV.VN
VOV2 - Đài Tiếng Nói Việt Nam

Kênh truyện cổ tích - Kể chuyện và hát ru cho bé là kênh chọn lọc những câu chuyện bổ ích và lý thú sẽ giúp các em có cách nhìn nhận cuộc sống đa màu sắc.Hãy bấm nút đăng ký nhé các em!
Đăng ký xem miễn phí tại: https://goo.gl/q27eOY" > /$FOLDER_CUR/hat-ru/$x
done 
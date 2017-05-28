#!/bin/bash

PAGE="$1"
ID=`echo $PAGE | awk -F '-cmobile*' {'print $2'} | awk -F . {'print $1'}`
INDEX=`echo $PAGE | awk -F '-cmobile*' {'print $1'} | awk -F "//" {'print $2}' | awk -F / {'print $2'}`

for x in {1..100}
do
	LINK="http://vov2.vov.vn/$INDEX-cmobile$ID-p$x.aspx"
	curl $LINK | grep -Po '(?<=href=")[^"]*' | egrep "/$INDEX/" | sort -u >> $INDEX.txt
	sed -i "s/c$ID/cmobile$ID/g" $INDEX.txt
done

link=`cat $INDEX.txt`
FOLDER_CUR=`pwd`
if [ ! -e $FOLDER_CUR/$INDEX ]
then
	mkdir -p $FOLDER_CUR/$INDEX
else
	ls $FOLDER_CUR/$INDEX *.txt | wc -l
fi
###
#
# INDEX: Ten chuyen muc
# ID: ID Chuyen muc
#
###

##
# 1. Tai va render
#	- Render theo anh nen
#
#
#
##

# #!/bin/bash

# PAGE="$1"
# ID=`echo $PAGE | awk -F '-cmobile*' {'print $2'} | awk -F . {'print $1'}`
# INDEX=`echo $PAGE | awk -F '-cmobile*' {'print $1'} | awk -F "//" {'print $2}' | awk -F / {'print $2'}`

# function get_link_bai_viet () {
# for x in {1..$1}
# do
	# LINK="http://vov2.vov.vn/$INDEX-cmobile$ID-p$x.aspx"
	# curl $LINK | grep -Po '(?<=href=")[^"]*' | egrep "/$INDEX/" | sort -u >> $INDEX.txt
	# sed -i "s/c$ID/cmobile$ID/g" $FOLDER_CUR/$INDEX/list.tmp
# done



# FOLDER_CUR=`pwd`
# if [ ! -e $FOLDER_CUR/$INDEX ]
# then
	# mkdir -p $FOLDER_CUR/$INDEX
	# get_link_bai_viet 100
# else
	# get_link_bai_viet 2
	# list_txt=`ls $FOLDER_CUR/$INDEX *.txt`
	# for name in $list_txt
		# do
			# name=`basename $name .txt`
			# echo "/$INDEX/$name.aspx" >> list.tmp
	# done
	# cat list.tmp | sort -u > file1.tmp
	# cat $FOLDER_CUR/$INDEX/list.tmp | sort -u | sed '/chuong-trinh/d' > file2.tmp
	# diff -a --suppress-common-lines -y file1.tmp file2.tmp | awk {'print $1'} > c.txt
# fi





# #link=`cat $INDEX.txt`
# }




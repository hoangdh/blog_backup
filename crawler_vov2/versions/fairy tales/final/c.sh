#!/bin/bash
list=$(cat list.txt | sort -u)
for x in $list
do

wget $x -O abc.html
cat abc.html | awk '/mp3/ {print $3}' | grep "mp3" | cut -d "\"" -f2 >> mp3.txt
cat abc.html | awk '/og:image/ {print $3}' | cut -d "\"" -f2 >> mp3.txt
rm -rf abc.html
done


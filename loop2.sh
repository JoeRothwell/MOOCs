#!/bin/sh

for i in $(ls *.csv)
do
	echo "First line of: "$i
	head -n 1 $i
	echo "--------------"
done

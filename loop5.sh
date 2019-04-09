#!/bin/sh

for i in $(ls *.vcf)
do
	echo "Last line of: "$i
	tail -n 2 $i
	echo "--------------"
done



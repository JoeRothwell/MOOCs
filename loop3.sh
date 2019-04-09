#!/bin/sh

# Loop on all the chromosomes in file, in "chromosomic" order
for chr in $(grep -v ^# $1 | cut -f1 | sort -uV)
do
	# Extract the nbr of varients matching this chr only (start the line, follow with empty space)
	numVariants=$(grep -c "^$chr\s" $1)
	
	#Print result
	echo "Chromosome "$chr" has "$numVariants" variants."
done

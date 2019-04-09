#!/bin/sh

# create a script to split a VCF by chromosome
for chr in $(grep -v "^#" $1 | cut -f1 | sort -uV)
do
	grep "^#" $1 > chrom_$chr.vcf
	grep "^$chr\s" $1 >> chrom_$chr.vcf
	
done



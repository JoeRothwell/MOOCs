#!/bin/sh

# Create a script that takes in argument VCF file
# and output the number of sample it contains
grep "^#CHROM" $1 |  cut -f10- | wc -w



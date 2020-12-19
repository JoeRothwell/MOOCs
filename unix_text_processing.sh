# Sort

# Can sort on a specific column, specify operator, etc
cat example_sort.txt
# Specify separator and sort on col 3. n is numeric sort, r reverses order
sort -t":" -k3,3 example_sort.txt
sort -t":" -k2,2n example_sort.txt
sort -t":" -k2,2 example_sort.txt
sort -t":" -k3,3 -k1,1rn example_sort.txt

# uniq

# Report or omit repeated lines: requires sorted input
cat example_uniq.txt
uniq example_uniq.txt
uniq -c example_uniq.txt
uniq -d example_uniq.txt
uniq -cd example_uniq.txt

# cut and paste

# removes sections (columns) from each line of files
cat example_cut.txt
cut –f1 example_cut.txt
cut -f1,2,3 example_cut.txt
cut -f-5 example_cut.txt

cut -f1,2 example_cut.txt > col12.txt
cut -f4,5 example_cut.txt > col45.txt
cut -f2 example_cut.txt > col2.txt

paste col12.txt col45.txt

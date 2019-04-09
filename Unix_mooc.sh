# Introduction to Unix course
# Print to the command line
echo "Hello World"

# to go back to the root
cd ~/

# make a directory
mkdir folder

# make a new file
touch journal-2017-01-24.txt

# the cat command is for concatenating files, but is often used to print
cat todo.txt todo.txt

# wc counts words and lines
wc Documents/A-tale-of-two-cities.txt

# less for viewing text files
less A-tale-of-two-cities.txt

#redirection
echo "I'm in the terminal"
echo "I'm in the file" > echoout.txt
echo "I've been appended" >> echoout.txt

# moving a file into a directory
mv journal-2017-01-24.txt journal

# rename
todo.txt todo-2017-01-24.txt

# copy
cp echoout.txt Desktop

# Week 2
# Find everything containing a wild card
ls 2017*
ls *.csv
ls *01.*







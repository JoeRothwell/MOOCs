# Introduction to Unix course
# Print to the command line
echo "Hello World"

# to go back to the root
cd ~/

# make a directory
mkdir folder
# not in course: make a directory inside another
mkdir -p outer/inner

# make a new file
touch journal-2017-01-24.txt

# the cat command is for concatenating files, but is often used to print
cat todo.txt todo.txt

# wc counts words and lines
wc Documents/A-tale-of-two-cities.txt

# less for viewing text files
less A-tale-of-two-cities.txt

# redirection
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

# Regular expressions: grep
grep "New" states.txt
grep "nia" states.txt

# Metacharacters with egrep. Dot represents any character
# plus sign is a quantifer representing more than one occurrence
egrep "i.g" states.txt
egrep "s+as" states.txt
egrep "s*as" states.txt
# Exact quantity of an expression: 2 or 3 adjacent Ss
egrep "s{2,3}" states.txt
egrep "(iss){2}"
egrep "(i.{2}){3}" states.txt

# All word, all number, all space characters. Capital letter for inverse
egrep "\w" small.txt
egrep "\d" small.txt
egrep "\s" small.txt

# Complement
egrep -v "\w" small.txt

# Character specific sets
egrep "[aeiou]" small.txt # contain ANY of these
egrep "[^aeiou]" small.txt # Don't contain ANY of these





# Week 3
# Make file in nano and run
bash math.sh
bash bigmath.sh

# Assign a variable and print
chapter_number=5
echo $chapter_number
let chapter_number=$chapter_number+1
the_empire_state="New York"
echo $the_empire_state

# Store result of command in a variable
math_lines=$(cat math.sh | wc -l)
echo $math_lines

# Variable names can be used inside strings
echo "I went to school in $the_empire_state"

# Bash program vars.sh that takes arguments
bash vars.sh
bash vars.sh red
bash vars.sh red blue
bash vars.sh red blue green

# Week 1
# Configuring git

git --version
git help
git config user.name
git config user.email

# Create a local repository
pwd
mkdir repos
cd repos mkdir projecta
cd projecta
git init 

# Verify that your project directory contains a .git directory
ls -a

# Make a file and add to the staging area
touch fileA.txt
git status 
git add fileA.txt
# add . adds all new files; add -u adds any updated/changed files
git status

# Ignore files by adding them to gitignore
cat .gitignore
echo "*.pdf" >> .gitignore
echo "*.csv" >> .gitignore
echo "*.dta" >> .gitignore
echo "*.svg" >> .gitignore
echo "*.rds" >> .gitignore

# Commit to a local repository
git commit -m "add fileA.txt"
git status

# See commit details
git log
git log --oneline
git log --pretty=oneline

# Clone a remote repository
git clone https://bitbucket.org/atlassian_tutorial/helloworld.git
cd helloworld
ls
# 
git remote -v
# url used to clone the repository is shown. Can use "origin" instead.

# Push to a remote repository. First clone a Bitbucket repository
git clone https://joerothwell@bitbucket.org/joerothwell/projectb.git
cd projectb
la -a
git remote -v
echo "# projectb's README" > README.md
# add file to staging area and commit
git add README.md
git commit -m "add README.md"
git status

# Push the commit to the remote repository. Origin is a shortcut for the URL
# and master is the branch to push. Local and remote repos are now sync'd.
git push -u origin master

# (Not in MOOC)
# To sync an existing R studio project with a github repo, they must first have the same name.
# Then get the project URL and do git remote
git remote add origin https://github.com/USERNAME/PROJECT.git

# If there are different files in the github repository, they must first be pulled
# Otherwise an error message will appear
git pull origin master --allow-unrelated-histories
git push -u origin master

# Rename a file (then stage and commit as usual)
git mv file.txt file_rename.txt

# Tag a commit for a version number. Must be pushed seperately
git tag -a v0.1 58d45f -m "First release"
git push origin v0.1


# MOOC week 2 Merging
# Perform a fast-forward merge
git branch feature2
git checkout feature2
echo "feature 2" >> fileA.txt
git commit fileA.txt -m "add feature 2"

# View commit graph and merge into master branch
git log --oneline --graph --all
# Change back to master branch, merge, delete feature2 branch label
git checkout master
git merge feature2
git branch -d feature2
# Note: the resulting commit history is linear

# Perform a merge commit (first do as above to add branch and feature 3)
git merge --no-ff feature3
# Delete the branch label as before.
git branch -d feature3

# Week 3 branching and merging
git clone https://joerothwell@bitbucket.org/joerothwell/projectb.git

# Make a new local repo with a text file with feature 1
mkdir projectd
git init
echo "feature 1" > fileA.txt
git add .
git commit -m "add feature 1"

# Make a new branch with feature 2
git branch feature2
git checkout feature2
echo "feature 2" >> fileA.txt
git add .
git commit -m "add feature 2"
git checkout master
echo "feature 3" >> fileA.txt
# You can add and commit in one command
git commit -a -m "add feature 3"

git merge feature2
# The branches contain a merge conflict!
git status
cat fileA.txt
git merge --abort
git merge feature2
# Open nano, fix file to have the 3 features and remove conflict markers
git add fileA.txt
git commit -m "Fixed conflict including the 3 features"
git branch -d feature2

# Push to a remote repository (to see what it looks like)
git remote add origin https://joerothwell@bitbucket.org/joerothwell/projectd.git
git push -u origin master


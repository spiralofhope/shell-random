#!/usr/bin/env  zsh



# Given a directory of files.
# Where the files are numbered.
# And the numbering begins at 2 instead of 1.
# Rename all the files, lowering each by one.



count=1
for i in *.jpg; do
  \mv $i $count.jpg
  count=$(($count+1))
done

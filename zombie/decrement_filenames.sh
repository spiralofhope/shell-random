#!/usr/bin/env  zsh



# Given a directory of files.
# Where the files are numbered.
# And the numbering begins at 2 instead of 1.
# Rename all the files, lowering each by one.
# Props to
#   http://www.linuxmisc.com/12-unix-shell/64e578a3b5840b56.htm



count=1
for i in *.jpg; do
  \mv $i $count.jpg
  count=$(($count+1))
done

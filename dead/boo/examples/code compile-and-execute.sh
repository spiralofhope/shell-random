#!/usr/bin/env  bash



# Make a text file with some code in it.
# run booc on it
# run mono on the resulting .exe

# As a bunch of Bash script you can paste into a terminal:

DIR=$PWD
TEMP=/tmp/boo.$PPID
mkdir $TEMP
cd $TEMP
echo 'print "Hello, world"' > hello.boo
booc $TEMP/hello.boo
mono hello.exe
cd $DIR
rm -rf $TEMP

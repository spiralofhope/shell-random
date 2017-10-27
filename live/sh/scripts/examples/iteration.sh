#!/usr/bin/env  sh



# GNU bash, version 4.3.33(1)-release (i686-pc-cygwin)
# GNU bash, version 4.3.30(1)-release (i586-pc-linux-gnu)
# zsh 5.0.7 (i586-pc-linux-gnu)
for i in $( \seq 1 1 10 ); do
  echo $i
done
echo
for i in $( \seq 10 -1 1 ); do
  echo $i
done
# Another way:
#for i in {1..10}; do echo $i; done
# With no line breaks:
#for i in {1..10}; do printf $i; done

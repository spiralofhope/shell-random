#!/usr/bin/env  zsh



# GNU bash, version 4.3.30(1)-release (i586-pc-linux-gnu)
# zsh 5.0.7 (i586-pc-linux-gnu)
numa=0 ; numb=3
until [ $numa -eq $numb ]; do
  ((numa++))
  echo iterating...
done

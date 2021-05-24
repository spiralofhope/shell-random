#!/usr/bin/env  sh


#   1.jpg  =>  001.jpg
#  10.jpg  =>  010.jpg
# 100.jpg  =>  100.jpg


# To dry run, use -n
\rename  's/^(\d.jpg)/0$1/'   *
\rename  's/^(\d\d.jpg)/0$1/' *

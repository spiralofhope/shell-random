#!/usr/bin/env  zsh



\rm  --force  filenames-to-fix.txt
# You better be damned sure findqueue is in working order.
findqueue  mp3  2> filenames-to-fix.txt

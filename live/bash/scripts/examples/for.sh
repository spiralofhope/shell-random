#!/usr/bin/env  bash
# shellcheck disable=1001
# shellcheck disable=1012
# shellcheck disable=1117
# shellcheck disable=2044
# "for" and filenames with spaces


# http://www.cyberciti.biz/faq/bash-for-loop-spaces/



#:<<'}'   #  for loop with spaces example
{
  O="$IFS"
  IFS="$( \echo -en "\n\b" )"
  for f in *; do
    \echo  "$f"
  done
  IFS=$O
}



#:<<'}'   #  To process all files passed as command line args:
{
  O="$IFS"
  IFS="$( \echo -en "\n\b" )"
  for f in "$@"; do
    \echo  "File: $f"
  done
  IFS=$O
}



:<<'}'   #  while loop with spaces example
{
  \find  .  |\
    \while  read -r  file; do
      \echo "$file"
    done
}



# Tested

# These will take a while to run on large directories.  It's pre-building the list to use.


# Works with files with spaces in their filename.
# FIXME - SC2044: For loops over find output are fragile. Use find -exec or a while read loop.
# I could also just use rename **/*.jpg
0="$IFS" ; IFS="$( \echo  -en "\n\b" )" ; for f in $( \find  .  -name *.JPG ); do \rename .JPG .jpg "$f" ; done ; IFS="$0"


# Per-directory, probably faster.
0="$IFS" ; IFS="$( \echo -en "\n\b" )" ; for f in $( \find  .  -type d ); do \rename .JPG .jpg ./* ; done ; IFS="$0"


# Preserve .JPG if found in the middle of a filename.
# Unfortunately my version of "rename" doesn't allow regular expressions, so the rename isn't preserving..
0="$IFS" ; IFS="$( \echo -en "\n\b" )" ; for f in $( \find  .  -regex '.*\.JPG$' ); do \rename .JPG .jpg "$f" ; done ; IFS="$0"

# Nice doesn't actually help the horrid system lag.  I tested:
0="$IFS" ; IFS="$( \echo  -en "\n\b" )" ; for f in $( \nice -n 16  \find  .  -type f  -regex '.*\.JPG$' ); do \nice  -n 16  \rename .JPG .jpg "$f" ; done ; IFS="$0"



:<<'}'   #  Ancient notes
{
for i in `ls *.wav`; do lame "$i" "$i".mp3 ; done
for i in `ls *.diff`; do patch -p1 < "$i" ; done

# Dealing with spaces in filenames:

find . -name '* *' | while read i; do echo "$i" ; done
find . -name 'example*' | while read i; do echo "$i" ; done

# unzipping a group of files into subdirectories (it's not very bright)

for i in `ls *.zip`; do mkdir "$i".dir ; unzip "$i" -d "$i".dir ; done
}

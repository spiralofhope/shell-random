#!/usr/bin/env  sh

# Recursive, regular expression rename that respects spaces



OLDIFS=$IFS
IFS=$( \echo -en "\n\b" )

for f in $( \find -regex '.*\.JPG$' ); do
  \echo  \mv "$f" "${f/.JPG/.jpg}"
done

IFS=$OLDIFS


# 0=$IFS ; IFS=$(echo -en "\n\b") ; for f in `find -regex '.*\.JPG$'`; do echo mv "$f" "${f/.JPG/.jpg}" ; done ; IFS=$0

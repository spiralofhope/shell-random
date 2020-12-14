#!/usr/bin/env  sh

# Recursive, regular expression rename that respects spaces
# To only use builtins I'd have to be able to recurse using `for` loops.. (the "global" routine in 4DOS).



OLDIFS=$IFS
IFS=$( \echo -en "\n\b" )

for f in $( \find -regex '.*\.JPG$' ); do
  \echo  \mv "$f" "${f/.JPG/.jpg}"
done

IFS=$OLDIFS


# 0=$IFS ; IFS=$(echo -en "\n\b") ; for f in `find -regex '.*\.JPG$'`; do echo mv "$f" "${f/.JPG/.jpg}" ; done ; IFS=$0

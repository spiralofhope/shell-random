#!/bin/bash



# Renaming using bash, instead of Perl's \rename



source=\-
target=x



for f in $( \ls *$source* ); do
  source2="$f"
  target2=$( \echo  "$f" | \sed  -e  "s/$source/$target/" )
  \mv  "$source2"  "$target2"
done

#!/usr/bin/env  sh



for i in ../*; do
  if [ -d "$i" ]; then
    if [ "$i" != "../_built" ]; then continue; fi
    find $i -type f
  fi
done
\find \
  > list-`\date +%Y-%m-%d`.txt

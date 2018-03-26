#!/usr/bin/env  sh

# Repairs and unzips a broken .zip file



file="ziprepair.$$.zip"
dir="$1".ziprepair.$$

\echo  y  |  \zip  --fixfix "$1"  --out "$file"
\mkdir  "$dir"
\cd     "$dir"
\unzip  -o  ../"$file"
\cd  -
\rm  --force  "$file"

#  \unzip  -tqq  $file  >> /dev/null 2>&1

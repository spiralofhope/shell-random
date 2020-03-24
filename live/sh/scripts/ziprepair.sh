#!/usr/bin/env  sh
# Repairs then unzips a broken .zip file



file="ziprepair.$$.zip"
dir="$1".ziprepair.$$

\echo  'y'  |  \zip  --fixfix "$1"  --out "$file"
\mkdir  "$dir"
\cd     "$dir"  ||  exit  1
\unzip  -o  ../"$file"
\cd  -  ||  exit  1
\rm  --force  "$file"

#  \unzip  -tqq  "$file"  >> /dev/null 2>&1

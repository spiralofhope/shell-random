#!/usr/bin/env  sh

# Repair a PDF
# https://blog.spiralofhope.com/?p=36213



input="$1"
output="$1.$$.pdf"


\gs \
  -o "$output" \
  -sDEVICE=pdfwrite \
  -dPDFSETTINGS=/prepress \
  "$input"

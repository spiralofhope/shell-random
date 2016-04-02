#!/usr/bin/env  sh

# 2016-03-25 - Tested and works
#   gpg (GnuPG) 1.4.16
#   Ubuntu 14.04.4 LTS  (Lubuntu)



_file=filename.ext
_gpg_signature=gpg-key-file.asc


\gpg  --keyid-format   long  --import  $_gpg_signature
\gpg  --keyid-format 0xlong  --verify  $_file

if [ $? = 0 ]; then
  \echo
  \echo '--'
  \echo 'Your file was tested, and passed'
  \echo '--'
  \echo
fi

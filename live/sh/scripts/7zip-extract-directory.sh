#!/usr/bin/env  sh



# --
# -- 7zip compression helper.
# --   Because it's really this difficult to remember how in the fuck to use it.
# --


if [ -z "$*" ]; then
  \echo  'Usage:'
  \echo  "  $( \basename $0 )  \"file.tar.7z\""
  \echo  ''
  \echo  "  $( \basename $0 )  \"file.tar.7z\"  \"target_directory\""
  \echo  ''
  return  1
fi


source="$1"
shift
if ! [ -z "$1" ]; then 
  target="$( \realpath  $1 )"
  shift
else
  target='./'
fi
\echo  "extracting from:  $source"
\echo  "extracting to:    $target"


# 7z
#   x             extract archive (.7z)
#   -so           write to standard out
# tar
#   x             extract archive (.tar)
#   f             unknown, and the man page doesn't say.
#   -             unknown, and the man page doesn't say.
#   --directory   the target directory
#   --verbose     verbose
\7z  x  -so  "$source"  |\
  \tar  xf  -  --directory="$target"  --verbose

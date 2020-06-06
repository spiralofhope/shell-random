#!/usr/bin/env  sh



# --
# -- 7zip compression helper.
# --   Because it's really this difficult to remember how in the fuck to use it.
# --


if   [ -z "$1" ]  \
|| ! [ -d "$1" ]; then
  \echo  'Usage:'
  \echo  "  $( \basename $0 )  \"source_directory\"  \"target_directory_for_file\""
  \echo  ''
  \echo  'For no compression (store):'
  \echo  "  $( \basename $0 )  \"source_directory\"  -m0"
  \echo  ''
  return  1
fi
# TODO - if the file already exists, prompt to insert into that existing archive


source="$1"
shift
if [ -z "$1" ]; then 
  target=$( \basename "$source" )
  target="./${target}.tar.7z"
else
echo here
  target="$( \realpath $1 )"
  target="${target}/${source}.tar.7z"
  shift
fi
\echo  "compressing:     $source"
\echo  "compressing to:  $target"
\echo  "additional flags:  $*"


# tar
#   --create   create archive (.7z)
#   f             unknown, and the man page doesn't say.
#   -             unknown, and the man page doesn't say.
# 7za
#   a          create archive (.tar)
#   -si        standard input
#   $*         any other inputs the user passes, like -m0 for no compression (store)
\tar  --create  -f  -  "$source" |\
  \7za  a   -si "$target"

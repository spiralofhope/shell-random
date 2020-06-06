#!/usr/bin/env  sh



# --
# -- 7zip compression helper.
# --   Because it's really this difficult to remember how in the fuck to use it.
# --


source="$1"
target=$( \basename "$source" )
target="./${target}.tar.7z"
shift
\tar  cf  -  "$source" |\
  \7za a -si "$*"  "$target"

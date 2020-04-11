#!/usr/bin/env  sh

# Incomplete



#:<<'}'   #  Create a blank file
{
  # Instead of
  #\touch  filename.ext
  # Do:
  tmp='replace-touch--filename.ext'
  :>                       "$tmp"
  \echo  'created'       \'"$tmp"\'
  \rm  --force  --verbose  "$tmp"
}

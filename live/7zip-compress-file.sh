#!/usr/bin/env  sh



# --
# -- 7zip compression helper.
# --   Because it's really this difficult to remember how in the fuck to use it.
# --



# TODO? - If -z $1, then prompt to doing all files in the current directory.

\7z  a  -mx=9  "$1".7z  "$1" && \
  \rm  --force  --verbose  "$1"

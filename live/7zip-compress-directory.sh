#!/usr/bin/env  sh



# --
# -- 7zip compression helper.
# --   Because it's really this difficult to remember how in the fuck to use it.
# --


\tar  cf  -  "$1" |\
  \7za a -si "$1".tar.7z

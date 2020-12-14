#!/usr/bin/env  sh



# Used with an optional parameter
\find  -L "${@:-.}"  -type l  2>/dev/null

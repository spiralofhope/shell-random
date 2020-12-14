#!/usr/bin/env  sh

# https://www.gnu.org/software/findutils/manual/html_node/find_html/Hard-Links.html
# Note: directories have one hard link for `.` and `..` and one for each subdirectory.. I think.



# Used with an optional parameter
\find  "${@:-.}"  -type f  -links  +1  2>/dev/null

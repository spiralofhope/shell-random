#!/usr/bin/env  sh


:<<'EXAMPLE'

dual-commands.sh  command  /some/path  /some/other/path  something

e.g. 

dual-commands.sh  geany  /some/path  /some/other/path   /foo/bar/baz.txt
=>
dual-commands.sh  geany  /some/path/foo/bar/baz.txt  /some/other/path/foo/bar/baz.txt


EXAMPLE


:<<'test_case'
dir1="/tmp/test 1/"
dir2="/tmp/test 2/"
file="some file"
\mkdir  "$dir1" \
        "$dir2"
\touch  "$dir1""$file" \
        "$dir2""$file"

dual-commands.sh  \ls  "$dir1"  "$dir2"  "$file"

\rm  -rf  /tmp/test*
test_case
"$1" "$2$4" "$3$4"

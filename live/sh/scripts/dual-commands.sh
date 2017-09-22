#!/usr/bin/env  sh


:<<'EXAMPLE'

dual-commands.sh  command  /some/path  /some/other/path  something

e.g. 

dual-commands.sh  geany  /some/path  /some/other/path   /foo/bar/baz.txt
=>
dual-commands.sh  geany  /some/path/foo/bar/baz.txt  /some/other/path/foo/bar/baz.txt


EXAMPLE


\exec  "$1"  "${2}""${4}"  "${3}""${4}"

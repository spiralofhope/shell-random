#!/usr/bin/env  sh



# If you need to debug a script, begin a shell with:
# \sh  -x



# You can run programs within programs like this:
\echo  "this is some text ` ls ` and some more"
# However, it's better to do this:
\echo  "this is some text $( ls ) and some more"


\read  variable < filename.ext
\echo  "$variable"


# Learn the pid of the current process with:
\echo  "$$PID"
# You can do things with this like make a quick-and-dirty tempfile
# \touch  /temp/some_tempfile.$PPID
# Though it's better for you to use `mktemp` (check my other scripts for my uses)



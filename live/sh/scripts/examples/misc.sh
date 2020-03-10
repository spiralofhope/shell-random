#!/usr/bin/env  sh



# If you need to debug a script, begin a shell with:
# \sh  -x



# You can run programs within programs like this:
\echo  "this is some text ` ls ` and some more"
# However, it's better to do this:
\echo  "this is some text $( ls ) and some more"


\read  variable < 'filename.ext'
\echo  "$variable"


# Learn the pid of the parent's process with:
\echo  "$PPID"

# Learn the pid of the current's process with:
\echo  "$$"


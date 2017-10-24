#!/usr/bin/env  sh



# TODO - De-reference symbolic links.  I think I have notes somewhere or other.


:<<'HEREDOC'
GNU coreutils
  http://www.gnu.org/software/coreutils/manual/coreutils.html
  'basename'
    http://www.gnu.org/software/coreutils/manual/coreutils.html#basename-invocation
    Alternate: 'cut' or with shell functionality.
  'dirname'
    https://www.gnu.org/software/coreutils/manual/coreutils.html#dirname-invocation
    Alternate: 'cut' or with shell functionality.
  'realpath'
    https://www.gnu.org/software/coreutils/manual/coreutils.html#realpath-invocation
HEREDOC



\echo  ' * Working with directories:'
\echo

\echo
\echo  'This file:'
# e.g.:  ./examples/filenames.sh
\echo  "$0"

\echo
\echo  'Its complete path:'
\echo  'Note - This "fills out" things like ./dir/file.ext'
# e.g.:  /some/dir/filenames.sh
\echo  "$( \realpath "$0" )"

\echo
\echo  'Its directory without its file:'
# e.g.:  ./examples
\echo  "$( \dirname "$0" )"

\echo
\echo  'Its complete directory path without its file:'
\echo  'Note - This "fills out" things like ./dir'
# e.g.:  /some/dir'
\echo  'Note - You might want to add a trailing slash yourself.'
\echo  "$( \dirname $( \realpath "$0" ) )"

\echo
\echo  'Its filename without its path:'
# e.g.:  filenames.sh
\echo  "$( \basename "$0" )"

\echo
\echo  'Its extension:'
# e.g.:  sh
\echo  "${0##*.}"

\echo
\echo  'Its filename without its path or extension:'
__="$( \basename "$0" )"
__="${__%.*}"
# e.g.:  filenames
\echo  "$__"



# ----------------------------------------------------------------------
\echo
\echo  '--'
\echo
\echo  ' * Working with directories:'
\echo

# These are simple examples, but being able to deal with more complex examples would require some heavier scripting:
#   - Count the number of subdirectories
#   - Show the second directory
#   - etc.

\echo  "Its directory's earliest directory is:"
# e.g.:  ./examples
__="$( \dirname "$0" )"
\echo  "$( \dirname "$__" )"

\echo
\echo  "Its directory's final directory is:"
# e.g.:  ./examples
__="$( \dirname "$0" )"
\echo  "$( \basename "$__" )"

\echo

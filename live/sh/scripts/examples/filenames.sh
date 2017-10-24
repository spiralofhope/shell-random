#!/usr/bin/env  sh



:<<'HEREDOC'
GNU coreutils
  http://www.gnu.org/software/coreutils/manual/coreutils.html
  'basename'
    http://www.gnu.org/software/coreutils/manual/coreutils.html#basename-invocation
  'dirname'
    https://www.gnu.org/software/coreutils/manual/coreutils.html#dirname-invocation
Alternate: 'cut' or with shell functionality.
HEREDOC



\echo  ' * Working with directories:'
\echo

\echo
\echo  'This file is:'
# e.g.:  ./examples/filenames.sh
\echo  "$0"

\echo
\echo  'Its directory without its file is:'
# e.g.:  ./examples
\echo  "$( \dirname $0 )"

\echo
\echo  'Its filename without its path is:'
# e.g.:  filenames.sh
\echo  "$( \basename $0 )"

\echo
\echo  'Its extension is:'
# e.g.:  sh
\echo  "${0##*.}"

\echo
\echo  'Its filename without its path or extension is:'
__="$( \basename $0 )"
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

\echo  "Its directory's earlier path is:"
# e.g.:  ./examples
__="$( \dirname $0 )"
\echo  "$( \dirname $__ )"

\echo
\echo  "Its directory's final path is:"
# e.g.:  ./examples
__="$( \dirname $0 )"
\echo  "$( \basename $__ )"

\echo

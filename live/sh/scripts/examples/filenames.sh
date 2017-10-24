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



\echo
\echo  'This file is:'
\echo  "$0"

\echo
\echo  'Its directory without the file is:'
\echo  "$( \dirname $0 )"

\echo
\echo  'Its filename without the path is:'
\echo  "$( \basename $0 )"

\echo
\echo  'Its extension is:'
\echo  "${0##*.}"

\echo
\echo  'Its base name is:'
__="$( \basename $0 )"
__="${__%.*}"
\echo  "$__"

\echo

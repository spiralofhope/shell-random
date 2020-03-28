#!/usr/bin/env  sh



# Make sure the command isn't run as an alias or function:
\echo example

# display some text
\echo  'example'

# display a variable
a='example'
\echo  "$a"
# Remember to use double-quotes.


# echo text without a line break (1)
\printf  'same'
\printf  'line'
# echo a blank line
\echo
# echo a blank line, more literally.  I find this easier to see.
\echo  ''
# In POSIX sh, echo flags are undefined:
#\echo  -n  also


# Escape codes
#   \n   line break
# Without the quotes, the \ will just tell it to 'escape' the next character, so it has no special meaning.
# shellcheck disable=1003
\printf  'a backslash:  \\'
\printf  '\n'

\printf  'a blank line:\n\n'

\printf  ' on one line '
\printf  ' on the same line \n'


# In POSIX sh, echo flags are undefined:
#\echo  -e  '\ntest\ntest'

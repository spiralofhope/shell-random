#!/usr/bin/env  sh



# Make sure the command isn't run as an alias or function:
\echo example

# display text
echo example

# echo text without a line break (1)
printf same
printf line
# echo a blank line
echo
# echo text without a line break (2)
echo -n also
echo -n thesame

# Escape codes
# \n
# Without the quotes, the \ will just tell it to 'escape' the next character, so it has no special meaning.
echo -e '\ntest\ntest'

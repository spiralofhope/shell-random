#!/usr/bin/env  sh
# Run a script, passing environment variables unique to it.


# For example, $SHELL is almost always set.
# But perhaps you want it to become something else.
# BUT only for the script and not anything else in your shell.
#
# Normally you would do something like the following on the commandline:
#
#   shell_old=$SHELL
#   SHELL=text
#   ./script.sh
#   SHELL=$shell_old
#   shell_old=
#
# While this works for some cases, what if you have many environment variables you wish to do this with?
#
# This is simplified using  `env`



\echo  "\$SHELL is currently:  $SHELL"
\echo  "\$HOME  is currently:  $HOME"


if [ -z "$1" ]; then
  # shellcheck disable=2016
  \env  SHELL='replacement $SHELL'  HOME='replacement $HOME'   "$0"  'parameter 1'  'parameter 2'
  
  :<<'  }'   #  It can be more neatly written like:
  {
  \env  \
    SHELL='replacement $SHELL'  \
    HOME='replacement $HOME'  \
    "$0"  \
      'parameter 1'  \
      'parameter 2'  \
    `#`
  }

fi

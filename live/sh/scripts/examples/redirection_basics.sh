#!/usr/bin/env  sh
# Examples of basic redirection.
# Sometimes you want to have a command "say nothing".
# Sometimes you only want a command to omit an error message.



# If it outputs something, let it.
\expr 10 + 10
\echo  $?
# =>
# 20
# 0


# Suppress regular output
\expr 10 + 10  > /dev/null
\echo  $?
# =>
# 0


# If it outputs something, let it.
\expr 10 + a
\echo  $?
# =>
# expr: non-integer argument
# 2


# If it outputs an error, stop it.
\expr 10 + a  2> /dev/null
\echo  $?
# =>
# 2


# If it outputs an error, or regular output, stop it.
\expr 10 + a  > /dev/null 2> /dev/null
\echo  $?
\expr 10 + 10 > /dev/null 2> /dev/null
\echo  $?
# =>
# 2
# 0


# Force commandline application non-interactivity
# Programs like FFmpeg can act non-interactively from a script, but if they're at a prompt they go interactive.  This screws up the copy-and-paste I like doing.
\expr 10 + 10  >/dev/null 2>/dev/null </dev/null

# You can also send it to the background:
\expr 10 + 10  >/dev/null 2>/dev/null </dev/null &

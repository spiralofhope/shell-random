#!/usr/bin/env  sh
# Examples of basic redirection.
# Sometimes you want to have a command "say nothing".
# Sometimes you only want a command to omit an error message.



#:<<'}'   #  If it outputs something, display it (no redirection).
{
\echo  $(( 10 + 10 ))
# =>
# 20
}


#:<<'}'   #  If it fails to execute and outputs error text, display it (no redirection).
{
\sh  --nonexistant_flag
# =>
# sh: 0: Illegal option --
# 
# Note that if the command generates an error then the whole script will halt and exit with that error code at this point.  See  `trapping-signals.sh`  for more.
}


#:<<'}'   #  Suppress regular (but not error) output
{
\echo  $(( 10 + 10 ))  > /dev/null
# =>
# 
# An example of an error:
\sh  --nonexistant_flag   > /dev/null
# =>
# sh: 0: Illegal option --
}


#:<<'}'   #  Suppress error (but not regular) output.
{
\sh  --nonexistant_flag   2> /dev/null
# =>
# 
}


#:<<'}'   #  Suppress regular and error output; display nothing.
{
\sh  --nonexistant_flag   > /dev/null  2> /dev/null
# =>
# 
}


#:<<'}'   #  Force commandline application non-interactivity
         # Programs like FFmpeg can act non-interactively from a script, but if they're at a prompt they go interactive.  This screws up the copy-and-paste I like doing.
{
\some_command  >/dev/null 2>/dev/null </dev/null
# =>
# 
# You can also send it to the background:
\some_command  >/dev/null 2>/dev/null </dev/null &
# =>
# 
}

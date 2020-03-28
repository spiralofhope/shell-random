#!/usr/bin/env  sh



#variable=1
#echo $variable



unset  variable
: "${variable:=example text one}"
\echo  "$variable"


variable='example'
#: "${variable:=}"
# Set the variable if it isn't already set
: "${variable:=example text two}"
\echo  "$variable"

# So you can do things like:

: "${PATH:=$PATH:example text two}"
\echo  "$PATH"

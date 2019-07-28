#!/usr/bin/env  sh


stty raw
variable=$( \dd bs=1 count=1 2> /dev/null )
stty -raw
\echo  'The result was:  '  $variable

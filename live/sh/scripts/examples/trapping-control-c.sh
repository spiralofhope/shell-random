#!/usr/bin/env  sh
# Trap INT / control-c / BREAK
# Tested 2017-10-24 on Devuan 1.0.0-jessie-i386-DVD with dash 0.5.7-4+b1



# INT is ^C
trap control_c INT

control_c()
{
  \echo  'control-c detected, exiting immediately.'
  # You can also exit this entire script with:
  #exit  0
}

\echo  'Unless you INT, this script will exit in 5 seconds.'
\sleep  5
\echo  'Exiting trap example.'
\echo  '(This text will not appear if you pressed control-c)'

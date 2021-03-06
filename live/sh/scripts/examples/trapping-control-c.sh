#!/usr/bin/env  sh
# Trap INT / control-c / BREAK
# Tested 2017-10-24 on Devuan 1.0.0-jessie-i386-DVD with dash 0.5.7-4+b1
# 
# http://man7.org/linux/man-pages/man1/trap.1p.html



# INT is ^C
trap control_c INT

control_c()
{
  \echo  'control-c detected, exiting immediately.'
  # You can also exit this entire script with:
  #exit  0

  # There is also this. (untested)
  # A negative PID kills the process group.
  #\kill  -TERM  -$$
}

\echo  'Unless you INT, this script will exit in 5 seconds.'
\sleep  5
\echo  'Exiting trap example.'
\echo  '(This text will not appear if you pressed control-c)'

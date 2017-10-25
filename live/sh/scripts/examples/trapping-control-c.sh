#!/usr/bin/env  sh
# Tested 2017-10-24 on Devuan 1.0.0-jessie-i386-DVD with dash 0.5.7-4+b1



# INT is ^C
trap control_c INT

control_c()
{
  \echo  'control-c detected.'
  # You can also exit this entire script with:
  #exit  0
}

for i in $( \seq  3  -1  1 ); do
  \echo  "Exiting in $i.."
  \sleep  1
done

\echo
\echo  'Exiting trap example."'

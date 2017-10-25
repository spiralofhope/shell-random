#!/usr/bin/env  sh



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

#!/usr/bin/env  sh



# INT is ^C
trap control_c INT

control_c()
{
  \echo  'control-c detected.'
  # You can also exit this entire script with:
  #exit  0
}

# for loop from 1/10 to 10/10
for a in $( \seq 1 10 ); do
  \echo  "$a/10 to Exit."
  \sleep  1
done

\echo  "Exiting trap example." 

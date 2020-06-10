#!/usr/bin/env  sh

# Run a program
# Where normally the script would launch it then continue
# Instead pause and wait for the program to exit before continuing



#:<<'}'   #  Method one:
# 2020-06-10 on Devuan beowulf_3.0.0_amd64
# 2019-08-09 on Debian 9.9.0-i386-xfce-CD-1
{
  # Notice the trailing '&' :
  \xclock &
  \wait
  \echo  ' * Ended. '
}


:<<'}'  #  Method two:
{
  # Notice the trailing '&' :
  \xclock &
  checkpid=$!
  \wait  $checkpid  &>  /dev/null
  \echo  ' * Ended. '
}

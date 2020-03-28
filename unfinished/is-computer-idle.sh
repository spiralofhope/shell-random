#!/usr/bin/env  sh

# use case:
# Check if my computer is idle - e.g. has finished all downloads
# If idle, suspend.
# I don't know.. maybe something like this:
# ./idle_check.sh  &&  \sudo  \pm-suspend
# but I'd have to have the user in the sudoers group for this command, so it can suspend unattended



is_cpu_idle(){
  # There's also  `procinfo`  on some systems.  I don't have access to it.
  # There's also  `w`
  # `top`  might have useful info, but perhaps not unattended.

  # Using  `uptime`  like this seems really fucking stupid.
  _1_minute_load_average=$( \uptime  |  \cut  --delimiter=','  --fields=3  |  \cut  --delimiter=' '  --fields=5 )
  __="$( \uptime  |  \cut  --delimiter=','  --fields=4 )"
  # Removing whitespace
  # shellcheck disable=2116
  _5_minute_load_average="$( \echo  "$__" )"
  __="$( \uptime  |  \cut  --delimiter=','  --fields=5 )"
  # Removing whitespace
  # shellcheck disable=2116
  _15_minute_load_average="$( \echo  "$__" )"
  \echo  "The  1 minute load average is:  _${_1_minute_load_average}_"
  \echo  "The  5 minute load average is:  _${_5_minute_load_average}_"
  \echo  "The 15 minute load average is:  _${_15_minute_load_average}_"
  #\uptime

  # TODO - What's a low load average that indicates low CPU usage?
  # TODO - "Low" may mean all kinds of things, depending upon what things I have going on in the background.. so this presumes nothing is.
  less_than='0.04'
  #__=$( \echo   "$_1_minute_load_average < $less_than"  |  \bc )
  __=$( \echo   "$_5_minute_load_average < $less_than"  |  \bc )
  #__=$( \echo  "$_15_minute_load_average < $less_than"  |  \bc )
  return  "$__"
}



# TODO
is_disk_idle(){
  #https://www.kernel.org/doc/Documentation/block/stat.txt
  #disk_activity="$( \cut  -b 91-99  <  '/sys/block/sda/stat' )"

  #\cat  /proc/diskstats
  #one line per device
  # if 9 has anything, then it's active
  # Either repeatedly-poll 9, or more occasionally poll 1 and 5 over a period of time
   #1  read I/Os       requests      number of read I/Os processed
   #2  read merges     requests      number of read I/Os merged with in-queue I/O
   #3  read sectors    sectors       number of sectors read
   #4  read ticks      milliseconds  total wait time for read requests
   #5  write I/Os      requests      number of write I/Os processed
   #6  write merges    requests      number of write I/Os merged with in-queue I/O
   #7  write sectors   sectors       number of sectors written
   #8  write ticks     milliseconds  total wait time for write requests
   #9  in_flight       requests      number of I/Os currently in flight
  #10  io_ticks        milliseconds  total time this block device has been active
  #11  time_in_queue   milliseconds  total wait time for all requests
  #12  discard I/Os    requests      number of discard I/Os processed
  #13  discard merges  requests      number of discard I/Os merged with in-queue I/O
  #14  discard sectors sectors       number of sectors discarded
  #15  discard ticks   milliseconds  total wait time for discard requests
  return  0
}



# --
# -- The actual work
# --

is_cpu_idle   ||  return  1
#is_disk_idle  ||  return  1

return  0

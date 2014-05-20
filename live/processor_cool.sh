#!/usr/bin/env  sh



# Maybe there's a better way to do this, but I don't know it.
get_the_number_of_processors() {
  \echo \
    \cat  /proc/cpuinfo |\
      \grep processor |\
      \tail  --lines=1 |\
      \cut  --bytes=13-
}



\echo  ' - cpufreq: Cooling down the processor(s)'

# `hardinfo` will prove that the CPU settings will change.
for i in $( \seq 0 $( get_the_number_of_processors ) ); do
  \sudo  \cpufreq-set  --cpu $i  --governor ondemand
done

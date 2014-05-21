#!/usr/bin/env  sh



# Maybe there's a better way to do this, but I don't know it.
get_the_number_of_processors() {
  \echo  $( \
    \cat  /proc/cpuinfo |\
      \grep processor |\
      \tail  --lines=1 |\
      \cut  --bytes=13- \
    )
}



# --



\echo -n ' - cpufreq: Cooling down the processor'
case $( get_the_number_of_processors ) in
  0)
    \echo ''
  ;;
  *)
    \echo 's'
esac


# `hardinfo` will prove that the CPU settings will change.
for i in $( \seq 0 $( get_the_number_of_processors ) ); do
  \sudo  \echo -n ''
  \echo  '   cooling down processor' $i
  \sudo  \cpufreq-set  --cpu $i  --governor ondemand
done

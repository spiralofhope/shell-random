#!/usr/bin/env  sh



# Get the governor status with something like:
# /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor

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



if ! [ $USER = 'root' ]; then
  /bin/su  -c  $0
else
  # `hardinfo` will prove that the CPU settings will change.
  for i in $( \seq 0 $( get_the_number_of_processors ) ); do
    if [ $i -eq 0 ]; then
      \echo  '   warming processor' $i
      \cpufreq-set  --cpu $i  --governor ondemand
      #\cpufreq-set  --cpu $i  --governor performance
     else
      \echo  '   chilling processor' $i
      \cpufreq-set  --cpu $i  --governor powersave
    fi
  done
fi

# cpufreq-set --max 300Mhz

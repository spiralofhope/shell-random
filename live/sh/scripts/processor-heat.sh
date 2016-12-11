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



_processor_heat() {
  \echo -n ' - cpufreq: Heating up the processor'
  case $( get_the_number_of_processors ) in
    0)
      \echo ''
    ;;
    *)
      \echo 's'
  esac

  # `hardinfo` will prove that the CPU settings will change.

  for i in $( \seq 0 $( get_the_number_of_processors ) ); do
    \echo  '   heating up processor' $i
    \cpufreq-set  --cpu $i  --governor performance
    pid=$!
  done
}



# --



# FIXME - this prevents ^c from operating as expected.
#         trap INT ?
get_char() {
  # Yes, getting a keystroke from the user is this stupid.  Welcome to Linuxville, population 1970.
  \stty  raw
  char=$( \dd  if=/dev/tty  bs=1  count=1  2>/dev/null )
  #\stty  -cbreak
  #\stty  -icanon
  \stty  -raw
  \echo  $char
}



if ! [ $USER = 'root' ]; then
  /bin/su  -c  $0
else
  case "$1" in
    '-y'|'--yes'|'')
      _processor_heat
    ;;
    '-p'|'--prompt')
      # FIXME - I have no idea how to get the enter key, with this reworked version.
      \echo  'Heat up the processor(s)? [Y/n]'
      case $( get_char ) in
        'y')
          _processor_heat
        ;;
        *)
          \echo  '(skipped)'
        ;;
      esac
    ;;
    *)
      \echo  '--yes, -y or nothing to automatically heat the processor(s) up'
      \echo  '--prompt, or -p to prompt the user'
    ;;
  esac
fi

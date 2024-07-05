#!/usr/bin/env  sh

#  Traditional bar-spinner with these characters:  -\|/



spinner_counter="$1"



#\printf  '   '
case "$spinner_counter" in
  1)
    output='-'
    spinner_counter='2'
  ;;
  2)
    # shellcheck disable=1003
    output='\'
    spinner_counter='3'
  ;;
  3)
    output='|'
    spinner_counter='4'
  ;;
  *)
    output='/'
    spinner_counter='1'
  ;;
esac
#\printf  '  '
\printf  "$output"
return  "$spinner_counter"



# Test
:<<'}'
{
  for i in 1 2 3 4 5; do
    _spinner "$i"
  done
}
# Expected output:
:<<'}'
/-\|/%
}

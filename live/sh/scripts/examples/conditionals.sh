#!/usr/bin/env  sh



# dash 0.5.7-4+b1
__='a'
#__=
if [ -z "$__" ]; then echo 'variable IS NOT set'
else                  echo 'variable IS set'
fi



# dash 0.5.7-4+b1
stringa='a'
#stringb='a'
stringb='b'
if   [   $stringa = $stringb ]; then echo 'variable strings ARE equal'
elif [ ! $stringa = $stringb ]; then echo 'variable strings ARE NOT equal'
fi



# dash 0.5.7-4+b1
__=1
if [ $__ -eq 1 ]; then echo 'EQUAL TO a number'; fi
if [ $__ -lt 2 ]; then echo 'LESS THAN a number'; fi
__=2
if [ $__ -gt 1 ]; then echo 'GREATER THAN a number'; fi



# dash 0.5.7-4+b1
if [ a = a ] && [ b = b ]; then echo 'both'; fi



# dash 0.5.7-4+b1
if [ a = a ] || [ a = b ]; then echo 'either'; fi



# sh executed via
# GNU bash, version 4.3.33(1)-release (i686-pc-cygwin)
var=0
case "$var" in
  0)
    echo $var is zero
  ;;
  1)
    echo $var is one
  ;;
  *)
    echo $var is neither zero nor one
  ;;
esac

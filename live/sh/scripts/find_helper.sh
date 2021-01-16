#!/usr/bin/env  sh
# shellcheck  disable=1001
#   (I like backslashes)



find_helper() {
  type="$1"
  color="$2"
  quotes="$3"
  shift; shift; shift   #  $4*
  if [ "$quotes" = 'quotes_on' ]; then
    \find  \
      ./  \
      -type  "$type"  \
      -iname  \*"$*"\*  \
    | \sed  's/^/"/'  \
    | \sed  's/$/"/'  \
    | \grep  \
        --colour="$color"  \
        --fixed-strings  \
        --ignore-case  \
        --  \
        "$*"
  else
      \find  \
      ./  \
      -type  "$type"  \
      -iname  \*"$*"\*  \
    | \grep  \
        --colour="$color"  \
        --fixed-strings  \
        --ignore-case  \
        --  \
        "$*"
  fi
}



find_helper  "$@"
# e.g.
# find_helper  'f'  'always'  'quotes_on'  "$*"

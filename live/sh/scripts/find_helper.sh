#!/usr/bin/env  sh
# shellcheck  disable=1001
#   (I like backslashes)



find_helper() {
  type="$1"
  color="$2"
  shift; shift   #  $3*
  \find  \
    ./  \
    -type  "$type"  \
    -iname  \*"$*"\*  |\
      \sed  's/^/"/'  |\
        \sed  's/$/"/'  |\
          \grep  \
            --colour="$color"  \
            --fixed-strings  \
            --ignore-case  \
            --  \
            "$*"
}



find_helper  "$@"




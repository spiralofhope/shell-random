#!/usr/bin/env  sh
# List files, DOS-style like `dir`
# https://blog.spiralofhope.com/?p=895



# This only partially supports wildcards because `tree` appears to be broken.
# You are better off doing things like dir/a|grep foo
# wildcards also screw up summaries
# wildcards also make it inappropriate to use tail, so detection is needed to work around that.
# wildcards have --dirsfirst ignored
# . basically wildcards suck.
dir() {
  #echo parameters:  _${*}_
  _my_parameters=''

  if   [ "$1" = '/ad' ] || [ "$1" = '/AD' ]; then  shift; _my_parameters="-d   -pugDF  $*"  #; echo _1
  elif [ "$1" = '/a'  ] || [ "$1" = '/A'  ]; then  shift; _my_parameters="-ahs  -pugDF  --timefmt '%Y-%m-%d'  $*"  #; echo _2
  elif [ "$1" = '/d'  ] || [ "$1" = '/D'  ]; then  shift; _my_parameters="-d            $*"  #; echo _3
  else                                                    _my_parameters="              $*"  #; echo _4
  fi

  # FIXME - I want --du but it can't exist alongside with a wildcard for unknown reasons.
  # I can remove the `tail` and things almost appear.  It's odd.
  #\echo "tree  -C  -i  -L 1  --dirsfirst  --timefmt '%Y-%m-%d'  --  $_my_parameters"
  \tree  --noreport  -C  -i  -L 1  --dirsfirst  $_my_parameters  |\
    ` # --no-init is mandatory for Windows Subsystem for Linux. `  \
    \less  --no-init  --RAW-CONTROL-CHARS  --quit-if-one-screen  --QUIT-AT-EOF

    #\tail  --lines='+2'  |\


  # Manually create a summary
  # TODO - only display it with /a (that would be annoying)
  # du doesn't seem to work.
  #\du  --all  --human-readable  --max-depth=0  $*
  #\echo  "$( \ls -ARgo "$@" | awk '{q += $3} END {print q}' ) bytes"
  __="$( \ls -ARgo "$@"  |  \awk '{q += $3} END {print q}' )"
  # add commas
  __=$( \echo  "$__"  |  \sed  --expression=':a'  --expression='s/\(.*[0-9]\)\([0-9]\{3\}\)/\1,\2/;ta' )
  \echo "$__ bytes total"
  unset  __

  unset  _my_parameters
}


#alias  DIR="   dir ''"
alias  dir/a=' dir /a'
alias  dir/ad='dir /ad'
alias  dir/d=' dir /d'

#!/usr/bin/env  sh
#
# FIXME - Does none of this work with pure Dash?  Sigh.



#:<<'}'   # Change directory into a directory-symbolic-link's real location, or a file's directory.
{
  # I'd love to hijack 'cd' directly using cd(), but that doesn't work.
  cdd() {
    local  target="$( \realpath "$*" )"
    if   [ -L "$*" ] && [ -d "$target" ] ; then  \cd  "$target"
    elif                [ -f "$target" ] ; then  \cd  "$( \dirname  "$target" )"
    else                                         \cd  "$*"
    fi
  }
}



#:<<'}'   #  Make and change into a directory:
{
  mcd() {
    directory="$@"
    if   [ -z "$1" ]; then
      directory="$( \date  +%Y-%m-%d )"
    elif [ -f "$*" ]; then   #  File
      directory="$( \dirname  "$@" )"
    fi
    # Silent errors:
    \mkdir  --parents  "$directory"
    \cd                "$directory"
  }
}



#:<<'}'   #  A nicer `df`
{
  #  This used to have  --exclude-type supermount
  #alias  df='\df  --human-readable'
  _df_sorted(){
    _df() {
      \df  --human-readable  --exclude-type tmpfs  --exclude-type devtmpfs
    }
    # The text at the top
    _df |\
      \head --lines='1'
    # The actual list of stuff
    _df |\
      \tail --lines='+2'  |\
      \sort --key=${1}
  }
}

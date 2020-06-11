#!/usr/bin/env  sh
# 4DOS-style dir, using a descript.ion file
# FIXME - this is godawfully slow.
# TODO - Do everything according to $LS_COLORS



_ddir() {
  # TODO/FIXME - setup-specific escape code.  See  `alarm.sh`
  _esc=''
  _boldon="${_esc}[1m"
  _boldoff="${_esc}[22m"
  _reset="${_esc}[0m"
  _blue="${_esc}[34m"
  _cyan="${_esc}[36m"
  # shellcheck disable=2034
  _grey="${_boldoff}${_esc}[37m"

  # FIXME - this is slow because it's re-reading the description for every single file.
  #   Read the descript.ion file into memory


  _get_description() {
    if [ ! -f 'descript.ion' ]; then return; fi
    #\echo  processing $*
    file_to_match="$*"


    _split_string() {
      set -f
      old_ifs=$IFS
      IFS=$2
      # shellcheck disable=2086
      set -- $1
      printf '%s\n' "$@"
      IFS=$old_ifs
      set +f
    }


    while IFS='' \read -r line; do
      # TODO - support one or more tabs
      # Before three or more spaces
      _line_file=$( _split_string  '   '  1  "$line" )
      _line_text=$( _split_string  '   '  2  "$line" )
      #_line_file=$( \echo "$line" | \awk -F'\ \ \ +' '{print $1}' )
#      _line_file=$( \echo "$line" | \awk -F'\ \ \ +' '{print $1}' )
      # After three or more spaces
#      _line_text=$( \echo "$line" | \awk -F'\ \ \ +' '{print $2}' )
      if [ "$_line_file"    = "$file_to_match" ]  ||\
         [ "$_line_file"'/' = "$file_to_match" ]       ` # directory ` ;\
      then
        _description="   $_line_text"
      fi
    done < 'descript.ion'
  }


  _ddir_process(){
    _description=''
    if [ -L "$*" ]; then
      # overrides color
      \printf  '%b'  "$_boldon$_cyan"
      \printf  '%s'  "$*"
    else
      \printf  '%s'  "$*"
    fi
    \printf  '%b'  "$_reset"
    _get_description  "$*"
    \echo     "$_description"
  }


  for i in *; do
    if [ -d "$i" ]; then
      \printf  '%b'  "$_boldon$_blue"
      _ddir_process "$i"
    fi
  done
  for i in .*; do
    if [ -d "$i" ]; then
      _ddir_process "$i"
    fi
  done
  for i in *; do
    if [ ! -d "$i" ]; then
      _ddir_process "$i"
    fi
  done
  for i in .*; do
    if [ ! -d "$i" ]; then
      _ddir_process "$i"
    fi
  done


  unset  _esc
  unset  _boldon
  unset  _boldoff
  unset  _reset
  unset  _blue
  unset  _cyan
  unset  _grey
  unset  _line_file
  unset  _line_text
  unset  _description
  unset  _split_string
}



_ddir "$*"  |\
  \head --lines='-1'  |\
  \less  --RAW-CONTROL-CHARS  --quit-if-one-screen  --QUIT-AT-EOF

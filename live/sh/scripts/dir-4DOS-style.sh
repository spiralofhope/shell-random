#!/usr/bin/env  sh

# 4DOS-style dir, using a descript.ion file
# TODO - Color everything according to $LS_COLORS
# TODO - Borrow from dir-DOS-style.sh and implement /a /d /ad



if [ $# -eq 0 ]; then
  # Pass example parameters to this very script:
  "$0"  .
  return
fi



if [ ! -f 'descript.ion' ]; then
  # Just run my regular script
  dir-DOS-style.sh
  return  1
fi
description=$( \cat  descript.ion )



# TODO/FIXME - setup-specific escape code.  See  `alarm.sh`
_esc=''
_boldon="${_esc}[1m"
_boldoff="${_esc}[22m"
_reset="${_esc}[0m"
_blue="${_esc}[34m"
_cyan="${_esc}[36m"
# shellcheck disable=2034
_grey="${_boldoff}${_esc}[37m"

# A tab:
# TODO - generate a tab instead of relying on it being embedded here.
description_separator='	'

# TODO - integrate the mechanics of the two scripts so I'm not calling external files.
process() {
  filename_color="$1"
  shift
  item="$*"
  # Iterate over the description
  \printf  '%s'  "${_reset}${filename_color}$item${_reset}"
  while IFS= read -r description_line; do
    left=$( split-string.sh  "$description_separator"  1  "$description_line" )
    if [ "$left" = "$item" ]; then
      description=$( split-string-output-all-after.sh  "$description_separator"  "$description_line" )
      \printf  '%s\n'  "  --  $description${_reset}"
      return
    fi
  done < 'descript.ion'
  \printf  '\n'
}


cd ~ || return
#for i in  *; do
  #process  "$i"
#done

# Directories
for i in * .*; do
  if ! [ -d "$i" ]  \
    || [ "$i" = '.'  ] \
    || [ "$i" = '..' ]; then
    continue
  fi
  if   [ ! -L "$i" ]; then  process  "${_boldon}${_blue}"   "$i"
  elif [   -L "$i" ]; then  process  "${_boldon}${_cyan}"   "$i"
  fi
done

# Not-directories
for i in * .*; do
  # Skip directories
  [ ! -d "$i" ] || continue
  if   [ ! -L "$i" ]; then  process  ''          "$i"
  elif [   -L "$i" ]; then  process  "${_cyan}"  "$i"
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

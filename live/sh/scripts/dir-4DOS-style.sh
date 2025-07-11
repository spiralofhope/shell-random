#!/usr/bin/env  sh

# 4DOS-style dir, using a descript.ion file
# TODO - Color everything according to $LS_COLORS
# TODO - Borrow from dir-DOS-style.sh and implement /a /d /ad
# TODO - Explore the `paste` command.  It is designed to build multi-column lists.



#if [ $# -eq 0 ]; then
  ## Pass example parameters to this very script:
  #"$0"  ~
  ##"$0"  ~  |  LESS=  \less  --no-init  --RAW-CONTROL-CHARS  --quit-if-one-screen
  #return  2> /dev/null || { exit; }
#fi



\cd  "$1"  ||  return  $?  2> /dev/null || { exit $?; }


if [ ! -f 'descript.ion' ]; then
  #echo '* WARNING:  No descript.ion file found.'
  # Just run my regular script
  dir-DOS-style.sh  $@
  return  2> /dev/null || { exit; }
fi

description=$( \cat  descript.ion )

# A tab:
description_separator=$( \printf '\t' )

# TODO/FIXME - setup-specific escape code.  See  `alarm.sh`
_esc=''
_boldon="${_esc}[1m"
#_boldoff="${_esc}[22m"
_reset="${_esc}[0m"
_blue="${_esc}[34m"
_cyan="${_esc}[36m"
# shellcheck disable=2034
#_grey="${_boldoff}${_esc}[37m"



process() {
  filename_color="$1"
  shift
  filesystem_entity="$*"
  # The colorized name of the file/directory/whatever, with no terminating carrage return.
  \printf  '%s'  "${_reset}${filename_color}$filesystem_entity${_reset}"
  # Iterate over the description and troll for a match.
  while IFS= read -r description_line; do
    # (Attempt to) trim $filesystem_entity (with the separator) from the beginning of $description_line
    description=${description_line##$filesystem_entity$description_separator}
    if [ ! "$description" = "$description_line" ]; then
      # I was able to trim $description_line, therefore I found an entry for $filesystem_entity
      \printf  '%s\n'  "  --  $description${_reset}"
      # No need to continue processing descript.ion
      return
    fi
  done < 'descript.ion'
  # After iterating through the whole descript.ion, no match was found.
  # Terminate the line with a carrage return.
  \printf  '\n'
}


# Directories
for i in * .*; do
  if [ ! -d "$i" ]  \
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

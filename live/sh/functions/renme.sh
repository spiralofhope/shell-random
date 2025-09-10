#!/usr/bin/env  sh
# Rename the current directory



renme() {
  if  [ $# -eq 0 ]  ||\
      [ "$PWD" = '/' ]  ||\
      [ "$*" = "$PWD" ];\
  then
    return  1
  fi
  #
  directory_desired="$*"
  directory_previous="$PWD"
  #\echo  "$directory_desired"
  #\echo  "$directory_previous"
  #
  \cd  ../  ||  return  $?
  #echo  "$*"

_safe_mv() {
  src="$1"
  dest="$2"

  # Resolve src to absolute path using realpath
  abs_src="$( \realpath "$src" 2>/dev/null )" || {
    \echo  "Error: Cannot resolve path: $src" >&2
    return  1
  }

  # Check if abs_src is the current directory:
  case "$abs_src" in
    "$PWD" | "$PWD/")
      # Resolve dest to absolute path using realpath
      abs_dest="$( \realpath "$dest" 2>/dev/null )" || {
        \echo  "Error: Cannot resolve path: $dest" >&2
        return  1
      }
      # Check if abs_dest is a subdirectory of $PWD:
      case "$abs_dest/" in
        "$PWD/"*)
          \echo  "Error: Cannot move $PWD to a subdirectory of itself: $dest" >&2
          return  1
        ;;
      esac
    ;;
  esac

  # Execute mv
  \mv  "$src" "$dest"  ||  return  1
}

  _safe_mv  "$directory_previous"  "$directory_desired"
  # If run as a function, then this will work:
  #   However, a script cannot make it's summoning shell  `cd`  into the new directory.
  \cd  "$directory_desired"  ||  \cd  "$directory_previous"  ||  return  $?
}



# Make sure my  `sourceallthat`  from  dash's  `.profile`  does not run this function (to suppress the echo):
# In  `~/.profile`  , if I don't realpath  $shdir  then I'd have to do this, because for some reason this script receives a parameter.
#if [ $( \realpath "$*" ) = "$PWD" ]; then
  #return  0
#fi

#renme  "$*"
#\echo  "$*"

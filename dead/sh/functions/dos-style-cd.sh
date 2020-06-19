#!/usr/bin/env  sh



# FIXME - this can't work, because dash does not support substitution in this way.
# The pure-sh-bible is giving bad advice here..

# Furthermore, I could not input a $1 like:
# CD 'A:\some\path'
# .. because the slashes are interpreted as an escape, and completely ruin the string.
# This whole endeavour is futile.

#return  0


#:<<'}'   #  Handle DOS-style paths.
CD() {

echo $1
return 0

  case  "$1"  in
    # check if the second character is a colon.
    ?:*)
      #\echo  'DOS-style'
      __="$1"
      __='A:\\test\\string'
      _directory=$( \printf  '%s\n'  "${__//\\//}" )
      _path=$( \printf  '%s\n'  "${_directory##?:}" )
      _drive_letter=$( \printf  '%s\n' "${${_directory}%%${_path}}" )
      \echo  "$__"
      \echo  "$_directory"
      \echo  "$_path"
      \echo  "$_drive_letter"
      case  "$( \printf  '%s\n'  "${_drive_letter%%:}" )"  in
        A)  _drive_letter='/mnt/a'  ;;
        B)  _drive_letter='/mnt/b'  ;;
        *)
          \echo  'CD() error'
        ;;
      esac
      \cd  "${_drive_letter}${_path}"  ||  return  $?
    ;;
    *)
      \cd  "$@"  ||  return  $?
    ;;
  esac
}

#!/usr/bin/env  sh


type=$1
color=$2




# TODO? - update this using the style of findreplace
_findhelper_find() {
  local  type=$1
  shift
  local  directory=$1
  shift
  \find  $directory               -type $type  -iname  \*"$1"\* |\
    \sed  's/^/"/' |\
    \sed  's/$/"/' |\
    \grep  --colour=always  --ignore-case  "$1"
}
#_findhelper_find() {
  #local  type=$1
  #shift
  #\find  -type $type  -iname  \*"$1"\* |\
  #\sed  's/^/"/'|\
  #\sed  's/$/"/' |\
  #\grep  --colour=always  --ignore-case  "$1"
#}


# Can double-quote to quote a single-quote.
#   "I don't know"
# Can backslash to escape.
#   I don\'t know
_findhelper_find_file_contents() {
  local maxdepth=$1
  shift
  \find  .  -maxdepth $maxdepth  -type f  -print0  -iname  \'"$*"\' |\
    \xargs  --no-run-if-empty  --null \
      \grep  --colour=always  --fixed-strings  --ignore-case  --regexp="$*"
}



case $1 in
  'file')
    shift
    _findhelper_find  f  $*
  ;;
  'directory')
    shift
    _findhelper_find  d  $*
  ;;
  '999')
    shift
    _findhelper_find_file_contents  999 $*
  ;;
  '1')
    shift
    _findhelper_find_file_contents  1   $*
  ;;
  *)
    \echo  'invalid usage'
  ;;
esac

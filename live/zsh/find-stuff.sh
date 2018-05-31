# TODO? - update this using the style of findreplace
# File/Directory-finding helpers.  Saves keystrokes.
# uses grep to colour.
findfile() {
  # TODO: parameter-sanity
  \find  -type f  -iname  \*"$1"\* |\
  \sed  's/^/"/'|\
  \sed  's/$/"/' |\
  \grep  --colour=always  --ignore-case  "$1"
}
finddir() {
  # TODO: parameter-sanity
  \find  -type d  -iname  \*"$1"\* |\
  \sed  's/^/"/' |\
  \sed  's/$/"/' |\
  \grep  --colour=always  --ignore-case  "$1"
}
findin() {
  maxdepth=$1
  shift
  __=$1
  shift
  if [ -z $1 ]; then
    \echo "Usage:

$0  <directory>  <string>


Multiple unquoted words are valid
  $0 . this is an example

If you do anything fancy, quote!
  $0 . 'asterisk * example'
"
  else
    \find  $__  -maxdepth $maxdepth  -type f  -print0  -iname  \'"$*"\' |\
    \xargs  --no-run-if-empty  --null \
      \grep  --colour=always  --fixed-strings  --ignore-case  --regexp="$*"
  fi
}
# TODO: parameter-sanity?
findinall() { findin 999 ./ "$*" ; }
findhere()  { findin 1   ./ "$*" ; }

findreplace() {
  if [ -z $3 ]; then
    \echo  "Usage:  $0 search replace [file|wildcard]."
    \return  1
  fi
  local  search=$1
  local  replace=$2
  shift
  shift
  \sed  --in-place  "s/$search/$replace/g"  $*
}

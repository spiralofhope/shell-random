#!/usr/bin/env  sh



#:<<'}}'  #  From sh
{{
findhelper() {
  case  $_findhelper_type  in
    'file')
      _findhelper_type='f'
    ;;
    'directory')
      _findhelper_type='d'
    ;;
    *)
      \echo  'invalid usage'
    ;;
  esac

  \find  \
    ./  \
    -type $_findhelper_type  \
    -iname  \*"$1"\*  |\
      \sed  's/^/"/'  |\
        \sed  's/$/"/'  |\
          \grep  \
            --colour=$_findhelper_color  \
            --ignore-case  "$1"  \
  ` # `

  _findhelper_type=
  _findhelper_color=
}


findfile() {
  _findhelper_type='file'
  _findhelper_color='always'
  findhelper  f  always  $*
}
findfile_color_off() {
  _findhelper_type='file'
  _findhelper_color='never'
  findhelper  f  never  $*
}



finddir() {
  _findhelper_type='directory'
  _findhelper_color='always'
  findhelper  $*
}
finddir_color_off() {
  _findhelper_type='directory'
  _findhelper_color='never'
  findhelper  $*
}



# Can double-quote to quote a single-quote.
#   "I don't know"
# Can backslash to escape.
#   I don\'t know
_findhelper_file_contents() {
  local  maxdepth=$1
  shift
  \find  \
    .  \
    -maxdepth $maxdepth  \
    -type f  \
    -print0  \
    -iname  \'"$*"\' |\
      \xargs  \
        --no-run-if-empty  \
        --null \
        \grep  \
          --colour=always  \
          --fixed-strings  \
          --ignore-case  \
          --regexp="$*"  \
    ` # `

  _findhelper_type=
  _findhelper_color=
}

# TODO - Technically I could make a `findin` that applies to only one file, but I won't bother.
findinall() {
  _findhelper_file_contents  999   $*
}


# TODO - Technically I could make a `findin` that applies to only one file, but I won't bother.
findhere() {
  _findhelper_file_contents  1   $*
}

}}



:<<'}}'  #  From zsh
{{
# Roughly copied here.
# TODO - audit

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
}}

#!/usr/bin/env  sh
# Helpers for `find`
# shellcheck  disable=1001
#   (I like backslashes)



#:<<'} }'
{
{
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
            --colour="$_findhelper_color"  \
            --ignore-case  "$1"

  unset  _findhelper_type
  unset  _findhelper_color
}


findfile() {
  _findhelper_type='file'
  _findhelper_color='always'
  findhelper  "$*"
}
findfile_color_off() {
  _findhelper_type='file'
  _findhelper_color='never'
  findhelper  "$*"
}



finddir() {
  _findhelper_type='directory'
  _findhelper_color='always'
  findhelper  "$*"
}
finddir_color_off() {
  _findhelper_type='directory'
  _findhelper_color='never'
  findhelper  "$*"
}



:<<'}'   #  Usage
{
 Can double-quote to quote a single-quote.
   "I don't know"
 Can backslash to escape.
   I don\'t know
}
_findhelper_file_contents() {
  maxdepth="$1"
  color="$2"
  shift; shift  #  $3*
  \find  \
    .  \
    -maxdepth "$maxdepth"  \
    -type f  \
    -print0  \
    -iname  \'"$*"\' |\
      \xargs  \
        --no-run-if-empty  \
        --null \
        \grep  \
          --colour="$color"  \
          --fixed-strings  \
          --ignore-case  \
          --regexp="$*"

  unset  _findhelper_type
  unset  _findhelper_color
  unset  maxdepth
}
findinall()           { _findhelper_file_contents  999   always  "$*" ;}
findinall_color_off() { _findhelper_file_contents  999   never   "$*" ;}
findhere()            { _findhelper_file_contents    1   always  "$*" ;}
findhere_color_off()  { _findhelper_file_contents    1   never   "$*" ;}



findin_helper() {
  color="$1"
  file="$2"
  shift; shift  #  $3*
  \grep  \
    --colour="$color"  \
    --fixed-strings  \
    --ignore-case  \
    --line-number  \
    "$*"  \
    --  \
    "$file"
}
# TODO?  Make others which don't use --line-number
findin()           { findin_helper  'always'  "$@" ;}
# I'm not sure why I'd ever want this:
#findin_color_off() { findin_helper  'never'   "$@" ;}


} }   #  end



:<<'}}'  #  From zsh
{
{
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
  search=$1
  replace=$2
  shift
  shift
  \sed  --in-place  "s/$search/$replace/g"  $*
  unset  search
  unset  replace
}
}}

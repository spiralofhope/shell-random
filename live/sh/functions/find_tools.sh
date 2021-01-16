#!/usr/bin/env  sh
# shellcheck  disable=1001
#   I like backslashes



findfile()     { find_helper.sh  'f'  'always'  'quotes_on'   "$@" ;}
findfile_raw() { find_helper.sh  'f'  'never'   'quotes_off'  "$@" ;}
finddir()      { find_helper.sh  'd'  'always'  'quotes_on'   "$@" ;}
finddir_raw()  { find_helper.sh  'd'  'never'   'quotes_off'  "$@" ;}


:<<'}'   #  Usage
{
 Can double-quote to quote a single-quote.
   "I don't know"
 Can backslash to escape.
   I don\'t know
}
findinall()     { findin_files.sh  999   'always'  "$@" ;}
findinall_raw() { findin_files.sh  999   'never'   "$@" ;}
findhere()      { findin_files.sh    1   'always'  "$@" ;}
findhere_raw()  { findin_files.sh    1   'never'   "$@" ;}



# TODO?  Make others which don't use --line-number
findin()        { findin_file.sh  'always'  "$@" ;}
# I'm not sure why I'd ever want this:
#findin_raw()    { findin_file.sh  'never'   "$@" ;}



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

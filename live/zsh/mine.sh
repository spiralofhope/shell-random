#!/usr/bin/env  zsh



 #This would be a nice idea to get rmdir to shut the fuck up.
:<<'}'   #  
rmdir2() {
  for i in $i; do if [ -f "$i" ]; then \rmdir "$i"; fi; done
}
:<<'}'  #  deduplicate_with_directories
# I haven't used this in forever, so it's being disabled.
deduplicate_with_directories() {
  \echo " * fdupes start.."
  \fdupes  -dnNr .
  \echo " * fdupes finished"
  #\rmdir  *
  for i in *; do
    if [ -d "$i" ]; then
      \rmdir  --ignore-fail-on-non-empty  "$i"
    fi
  done
  if [ "$( \find  .  -maxdepth 1  |  \wc  --lines )" -eq 0 ]; then
    # probably a zshism
    # shellcheck disable=2035
    \mv  */* .
#    \rmdir  *
    for i in *; do
      if [ -d "$i" ]; then
        \rmdir  --ignore-fail-on-non-empty  "$i"
      fi
  done
  fi
}



:<<'}'   #  Check for root, and die if not.
#  There's no real point to this, as I do root-checking and password-prompting in scripts that need it.
be_root_or_die() {
  if [ "$( \whoami )" != 'root' ]; then
    \echo  "ERROR:  You're not root!"
    exit  1
  fi
}



:<<'}'   #  Re-load all these zsh libraries.
re_source() {
  for i in /live/OS/Linux/shell-random/git/live/zsh/*.sh; do
    # shellcheck disable=1090
    # zshism
    # shellcheck disable=2039
    source  "$i"
  done
}



:<<'}'   #  What the fuck was this for, anyways?
rmln() {
  # TODO:  Sanity checking
  rmln_target="$( \basename  "$1" )"
  \echo  "$rmln_target"
  \rm  --interactive=once  --recursive  --verbose  "$rmln_target"
  \ln  --symbolic  --verbose "$1"  .
}



## TODO - count the number of files in subdirectories.
## TODO - count the number of subdirectories.
## TODO - count the number of symlinks.
## TODO - count the number of hard links.
## TODO - Use printf and a fixed field width instead of using tabs?
##        Or can I set where the first tab stop is?
## FIXME - `du` fails when doing something like `c foo*` where one of the directories of foo* has a space in it.
#:<<'}'
#c() {
  #c_count() {
    #count=$( \find  .  -maxdepth 1 | \wc -l )
    #count=$( comma "$count" )
    #\echo  "$count"
  #}
  #c_size() {
    ## The size of those files (and subdirectories - FIXME)
    #size="$( \du --bytes --summarize "$1" )"
    ## Everything before the space.
    ## I don't know why I can't make this ${ ${ and it must be ${${
    ## zshism
    ## shellcheck disable=2116
    #size=${$( \echo "$ssize" )[1]}
    #size=$( comma "$size" )
    #\echo  "$size"
  #}
  #c_samecheck(){
    ## zshisms
    ## shellcheck disable=1009
    ## shellcheck disable=1073
    ## shellcheck disable=2039
    #if [ "$1" == "$2" ]; then
      #\echo  "  same"
    #else
      #\echo  "  DIFFERENT"
    #fi
  #}

  #if [ -z "$*" ]; then
    #count=$( c_count ./ )
    #\echo  "$count files."

    #size=$( c_size ./ )
    #\echo  "$size bytes."
  #elif [ -z "$2" ]; then
    #\echo  "For $1"

    #count=$( c_count "$1" )
    #\echo  "$count files."

    #size=$( c_size "$1" )
    #\echo  "$size bytes."
  #elif ! [ -z "$2" ]; then
    #count_one=$( c_count "$1" )
    #count_two=$( c_count "$2" )
    #\echo  "Files:"
    #\printf  '  %s: \t %s'  "$1"  "$count_one"
    #\printf  '  %s: \t %s'  "$2"  "$count_two"
    #c_samecheck  "$count_one"  "$count_two"

    #\echo

    #size_one=$( c_size "$1" )
    #size_two=$( c_size "$2" )
    #\echo  "Size:"
    #\printf  '  %s: \t %s'  "$1"  "$size_one"
    #\printf  '  %s: \t %s'  "$2"  "$size_two"
    #c_samecheck  "$size_one"  "$size_two"
  #fi
#}



alias mcedit='\mcedit  --colors  editnormal=lightgrey,black'
#alias edit='/usr/bin/sanos-simple-text-editor'

:<<'}'   #  run an editor
#  I haven't used this in forever, and it's been commented-out for a long while..
edit() {
  # I'm in X, I'm at the raw console and X is launched.
  if  !  \
    \geany --new-instance  "$@"s > /dev/null 2>&1
  then
    # X is not launched at all.  It might be sitting at the login screen though.
    \mcedit  "$@"
  fi
}




:<<'}'   #  Find and enter the highest numbered directory
# FIXME - this doesn't work to go to 0.0.99 instead of 0.0.1
cdv() {
  if [ ! "x$1" = "x" ]; then
    # TODO: Sanity-check on $1 (a directory, exists, whatever)
    \cd "$1"  ||  return  $?
  fi
  # Translation:  Only directories | only n.n.n format | remove trailing slash.| only the last entry
  \cd  "$( \
    \find  .  -maxdepth 1  -type d  |\
    \grep  '[0-9]*\.[0-9]*\.[0-9]'  |\
    \sed  's/\.\///'  |\
    \tail  --lines=1  \
  )"  ||  return  $?
}



:<<'}'   #  Hard unmount notes.  No way.
umount() {
  if [ "$#" = "0" ] || [ "$1" = "--help" ]; then
    /bin/umount "$@"
  else
    # TODO: Maybe there's a way for me to capture the output into a HEREDOC?  That would be far cleaner.
    # Run it, being hopeful.
    if  !  \
      /usr/bin/umount-root  "$@"  >/dev/null 2>&1
    then
      # If it errored out, run it again but see the error this time.
      /usr/bin/umount-root  "$@" 
    fi
  fi
}



:<<'}'  #  If a file exists, act on it.
# warning: Your command won't prompt!  (so rm will nuke files)
ifexists() {
  if [ -e "$2" ]; then
    "$1" "$2"
  fi
}



_jpegoptimize() {
  amount=$1
  shift
  \jpegoptim  --max="$amount"  --preserve  "$@"
  if [ "$amount" -ne 100 ]; then
    :>  "zz--  jpegoptim -m$amount"
  fi
}

# Not happy:
#   for i in *; if [[ -d $i ]]; then cd $i; jpegoptim100; fi; cd -
# Try:
#   jpegoptim100 **/*.jpg
# zshisms
jpegoptim100() { _jpegoptimize 100 "$@" }
jpegoptim95()  { _jpegoptimize  95 "$@" }
jpegoptim90()  { _jpegoptimize  90 "$@" }
jpegoptim85()  { _jpegoptimize  85 "$@" }
jpegoptim80()  { _jpegoptimize  80 "$@" }
jpegoptim50()  { _jpegoptimize  50 "$@" }


# I don't know why I had this uncommented in aliases.sh, but I'm moving it here and disabling it.
:<<'}'   #  Disabled rm
#alias  rm='nocorrect  \rm  --interactive'
# Making rm smarter so it can remove directories too.  Fuck you, GNU.
# TODO? - Know when there are contents in directories to delete them?  It doesn't seem right to do this..
rm() {
  # TODO? - Shouldn't this loop through $* and rmdir any directories?
  if [ -d "$1" ] && [ ! -L "$1" ]; then
    \rmdir  --verbose  "$1"
  else
    # I can't use \rm here, because it somehow still uses rm()
    nocorrect  /bin/rm  --interactive  "$*"
  fi
}

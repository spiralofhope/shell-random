#!/usr/bin/env  zsh



# This would be a nice idea to get rmdir to shut the fuck up.
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
  if [[ $( \ls . -1  |  \wc  --lines ) -eq 0 ]]; then
    \mv  */* .
#    \rmdir  *
    for i in *; do
      if [ -d "$i" ]; then
        \rmdir  --ignore-fail-on-non-empty  "$i"
      fi
  done
  fi
}



:<<'}'  #  Check for root, and die if not.
#  There's no real point to this, as I do root-checking and password-prompting in scripts that need it.
be_root_or_die() {
  if [ $( \whoami ) != 'root' ]; then
    \echo  "ERROR:  You're not root!"
    exit  1
  fi
}



#:<<'}'   #  Re-load all these zsh libraries.
re_source() {
  for i in /l/OS/bin-mine/shell-random/git/live/zsh/*.sh
    source  $i
}



:<<'}'   #  What the fuck was this for, anyways?
rmln() {
  # TODO:  Sanity checking
  rmln_target=$( \basename $1 )
  \echo  $rmln_target
  \rm  --interactive=once  --recursive  --verbose $rmln_target
  \ln  --symbolic  --verbose $1 .
}



# TODO - count the number of files in subdirectories.
# TODO - count the number of subdirectories.
# TODO - count the number of symlinks.
# TODO - count the number of hard links.
# TODO - Use printf and a fixed field width instead of using tabs?
#        Or can I set where the first tab stop is?
# FIXME - `du` fails when doing something like `c foo*` where one of the directories of foo* has a space in it.
:<<'}'
c() {
  c_count() {
    local  count=$( \ls -1 "$1" | \wc -l )
    local  count=$( comma $count )
    \echo  $count
  }
  c_size() {
    # The size of those files (and subdirectories - FIXME)
    local  size="$( \du --bytes --summarize \"$1\" )"
    # Everything before the space.
    # I don't know why I can't make this ${ ${ and it must be ${${
    local  size=${$( \echo "$size" )[1]}
    local  size=$( comma $size )
    \echo  $size
  }
  c_samecheck(){
    if [ $1 == $2 ]; then
      #\echo  "  same"
    else
      \echo  "  DIFFERENT"
    fi
  }

  if [ -z $1 ]; then
    local  count=$( c_count ./ )
    \echo  "$count files."

    local  size=$( c_size ./ )
    \echo  "$size bytes."
  elif [ -z $2 ]; then
    \echo  "For $1"

    local  count=$( c_count "$1" )
    \echo  "$count files."

    local  size=$( c_size $1 )
    \echo  "$size bytes."
  elif ! [ -z $2 ]; then
    local  count_one=$( c_count "$1" )
    local  count_two=$( c_count "$2" )
    \echo  "Files:"
    \echo -e "  $1: \t $count_one"
    \echo -e "  $2: \t $count_two"
    c_samecheck $count_one $count_two

    \echo

    local  size_one=$( c_size "$1" )
    local  size_two=$( c_size "$2" )
    \echo  "Size:"
    \echo -e "  $1: \t $size_one"
    \echo -e "  $2: \t $size_two"
    c_samecheck  $size_one  $size_two
  fi
}



alias mcedit='\mcedit  --colors  editnormal=lightgrey,black'
#alias edit='/usr/bin/sanos-simple-text-editor'

:<<'}'   #  run an editor
#  I haven't used this in forever, and it's been commented-out for a long while..
edit() {
  # I'm in X, I'm at the raw console and X is launched.
  \geany --new-instance  $@ > /dev/null 2>&1
  if [ "$?" != "0" ]; then
    # X is not launched at all.  It might be sitting at the login screen though.
    mcedit  $@
  fi
}




:<<'}'   #  Find and enter the highest numbered directory
# FIXME - this doesn't work to go to 0.0.99 instead of 0.0.1
cdv() {
  if [ ! "x$1" = "x" ]; then
    # TODO: Sanity-check on $1 (a directory, exists, whatever)
    \cd "$1"
  fi
  # Translation:  Only directories | only n.n.n format | remove trailing slash.| only the last entry
  \cd $( \ls  -1  --directory */ | \grep  '[0-9]*\.[0-9]*\.[0-9]' | \sed  's/\///' | \tail  --lines=1 )
}



:<<'}'   #  Hard unmount notes.  No way.
umount() {
  if [ "$#" = "0" ] || [ "$1" = "--help" ]; then
    /bin/umount "$@"
  else
    # TODO: Maybe there's a way for me to capture the output into a HEREDOC?  That would be far cleaner.
    # Run it, being hopeful.
    /usr/bin/umount-root "$@" >/dev/null 2>&1
    if [ ! "$?" = "0" ]; then
      # If it errored out, run it again but see the error this time.
      /usr/bin/umount-root "$@"
    fi
  fi
}



:<<'}'  #  If a file exists, act on it.
# warning: Your command won't prompt!  (so rm will nuke files)
ifexists() {
  if [ -a "$2" ]; then
    "$1" "$2"
  fi
}



_jpegoptimize() {
  amount=$1
  shift
  \jpegoptim  --max=$amount  --preserve  "$@"
  if [ $amount -ne 100 ]; then
    \touch  "zz--  jpegoptim -m$amount"
  fi
}

# Not happy:
#   for i in *; if [[ -d $i ]]; then cd $i; jpegoptim100; fi; cd -
# Try:
#   jpegoptim100 **/*.jpg
jpegoptim100() { _jpegoptimize 100 "$@" }
jpegoptim95()  { _jpegoptimize  95 "$@" }
jpegoptim90()  { _jpegoptimize  90 "$@" }
jpegoptim85()  { _jpegoptimize  85 "$@" }
jpegoptim80()  { _jpegoptimize  80 "$@" }
jpegoptim50()  { _jpegoptimize  50 "$@" }


# TODO - deduplicate this
vbrfixit() {
  if [ -z $1 ]; then
    for i in *; do
      \echo ----- "$i"
      if [ -f "$i" ]; then
        \vbrfix  -always  "$i"  out
        \mv  --force  out  "$i"
      fi
    done
  else
    if [ -f "$i" ]; then
      \vbrfix  -always  "$i"  out
      \mv  --force  out  "$i"
    fi
  fi
}




# I don't know why I had this uncommented in aliases.sh, but I'm moving it here and disabling it.
:<<'}'   #  Disabled rm
#alias  rm='nocorrect  \rm  --interactive'
# Making rm smarter so it can remove directories too.  Fuck you, GNU.
# TODO? - Know when there are contents in directories to delete them?  It doesn't seem right to do this..
rm() {
  # TODO? - Shouldn't this loop through $* and rmdir any directories?
  if [ -d $1 ] && [ ! -L $1 ]; then
    \rmdir  --verbose  "$1"
  else
    # I can't use \rm here, because it somehow still uses rm()
    nocorrect  /bin/rm  --interactive  "$*"
  fi
}



ytdl() {
  # To test the filename:
#    --get-filename  \
    #` # I suspect this is important for an NTFS filesystem. `  \
    #--restrict-filenames  \
#

  \youtube-dl  \
    --audio-format  best  \
    --write-description  \
    --write-info-json  \
    --write-annotations  \
    --write-all-thumbnails  --embed-thumbnail  \
    --all-subs  --embed-subs  \
    --add-metadata  \
    --no-call-home  \
    ` # Note that a base directory  ./  does not work (for subtitles) `  \
    --output '%(uploader)s/%(upload_date)s - %(title)s/%(title)s.%(ext)s'  \
    -f best  \
    "$@"

# TODO - detect control-c
#if [ $? -ne 0 ]; then return 1; fi

  # Trailing periods are invalid on Windows; remove them:
  #
  # Testing:
  # \rmdir **/* ; \rmdir * ; \mkdir  --parents  a/a.  b/b.  c/c  a/testing.one.  a/testing.two  a/testing.a.three.  a/testing.a.four
  for directory in *.; do
    if [ -d "$directory" ]; then
      \mv  "$directory" "$(basename "$directory" .)"
    fi
  done

  for directory in *; do
    if [ -d "$directory" ]; then
      \cd  "$directory"  > /dev/null
      for subdirectory in *.; do
        if [ -d "$subdirectory" ]; then
          \mv  "$subdirectory" "$(basename "$subdirectory" .)"
        fi
      done
      \cd  -  > /dev/null
    fi
  done

  # I have no idea how to use youtube-dl's --output to fix the date format, so do it manually:
  # Testing:
  # \mkdir  --parents  a  '12345678 - one'  '1234-5678 - two'  '1234-56-78 - three'  a/a  'a/12345678 - one'  'a/1234-5678 - two'  'a/1234-56-78 - three'
  for directory in *; do
    if [ -d "$directory" ]; then
      \cd  "$directory"  > /dev/null

      # Testing:
      # \rmdir **/* ; \rmdir * ; \mkdir  --parents  a  '12345678 - one'  '1234-5678 - two'  '1234-56-78 - three'
      for subdirectory in *; do
        if [ -d "$subdirectory" ]; then
          target=$( \echo  "$subdirectory" | \sed 's/\(^[0-9]\{4\}\)\([0-9]\{2\}\)/\1-\2-/' )
          if ! [ "$subdirectory" == "$target" ]; then
            \mv  "$subdirectory"  "$target"
          fi
        fi
      done

      \cd  -  > /dev/null
    fi
  done
}

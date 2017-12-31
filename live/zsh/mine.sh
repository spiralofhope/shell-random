#!/usr/bin/env  zsh
# TODO - Rename this file.  Move it into lib.sh?


\which  sudo > /dev/null
if [ $? -eq 0 ]; then
  _sudo_exists='true'
else
  _sudo_exists='false'
fi



# 2016-03-26, on Lubuntu (version not recorded)
# 2016-03-28, on Slackware 14.1
#alias  su="\sudo  $( \basename  $( \readlink  /proc/$$/exe ) )"
#alias  sul='\sudo  \su  --login'

# All instances of 'su' will be "under one roof", to avoid multiple instances of a root window.  Because that's terribly insecure.
# 2016-03-29, on Slackware 14.1
su() {
  if [ $_sudo_exists = 'true' ]; then
    \sudo  $1  \screen  -X setenv currentdir `\pwd`
    \sudo  $1  \screen  -X eval 'chdir $currentdir' screen
    # This logs out of any existing instance of root.
    \sudo  $1  \screen -A  -D -RR
  else
    # 2016-10-29, on Porteus-LXQt-v3.1-i486
    /bin/su
  fi
}
sul() {
  /bin/su  '--login'
}
# Let root become the user.
# Basically the reverse of the above.
# TODO - tweak this to make a sort of `sudouser`
# 2016-04-01, on Slackware 14.1
suu() {
  if [ -z $1 ]; then
    \sudo  -u user  $SHELL
  else
    \sudo  $*
  fi
}
suul() {
  suu  '--login  -u user'
}



# 2016-10-29, on Porteus-LXQt-v3.1-i486
if [ $_sudo_exists = 'false' ]; then
  sudo() {
    /bin/su  -c $*
  }
fi



# This would be a nice idea to get rmdir to shut the fuck up.
#rmdir2() {
#for i in $i; do if [ -f "$i" ]; then \rmdir "$i"; fi; done
#}
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



# TODO - How could I make this into something reusable?  e.g.:
  # until false; do sudo df -h | grep /mnt/tmp ; sleep 1m ; done
: << 'FAIL_repeat'
repeat() {
  __=$1
  shift
  until false; do
    $( $1* )
    sleep __
  done
}
FAIL_repeat



be_root_or_die() {
  if [ $( \whoami ) != 'root' ]; then
    \echo  "ERROR:  You're not root!"
    exit  1
  fi
}



ziprepair() {
  file=ziprepair.$$.zip
  dir="$1".ziprepair.$$
  \echo  y  |  \zip  --fixfix "$1"  --out $file
  \mkdir  "$dir"
  \cd  "$dir"
  \unzip  -o  ../$file
  \cd  -
  \rm  --force  $file
#  \unzip  -tqq  $file  >> /dev/null 2>&1
}



re_source() {
  for i in /l/shell-random/git/live/zsh/*.sh
    source  $i
}



# What the fuck was this for, anyways?
DISABLED_rmln() {
  # TODO:  Sanity checking
  rmln_target=$( \basename $1 )
  \echo  $rmln_target
  \rm  --interactive=once  --recursive  --verbose $rmln_target
  \ln  --symbolic  --verbose $1 .
}



# 1.tar.bz2 => tar.bz2 (good, but...)
#   it also does 1.test.test.tar.bz2 => test.test.tar.bz2 (bad idea!)
# EXT=${AUTOTEST_FILE#*.}
# 1.tar.bz2 => bz2 (better!)
# Is this problematic code for other shells?
#EXT=${AUTOTEST_FILE##*.}



# TODO - count the number of files in subdirectories.
# TODO - count the number of subdirectories.
# TODO - count the number of symlinks.
# TODO - count the number of hard links.
# TODO - Use printf and a fixed field width instead of using tabs?
#        Or can I set where the first tab stop is?
# FIXME - `du` fails when doing something like `c foo*` where one of the directories of foo* has a space in it.
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

#edit() {
  ## I'm in X, I'm at the raw console and X is launched.
  #\geany --new-instance  $@ > /dev/null 2>&1
  #if [ "$?" != "0" ]; then
    ## X is not launched at all.  It might be sitting at the login screen though.
    #mcedit  $@
  #fi
#}



# TODO: implement 'global' with find
# or just do (zsh):
# For directories:  **/
# For files:  **
# This doesn't work..
#global() {
  #if [ x$1 = x ]; then return 0; fi
  #for i in *; do
    #$@
  #done
#}
global() {
  \echo  "use **"
}
globaldirs() {
  \echo  "use **/"
}
#globaldirs() {
  #EXEC="$@"
  #EXEC=(${=EXEC})
  #\echo $EXEC
  #for globaldirs in **/; do
    #cd "$globaldirs"
    ##\echo $EXEC
    #cd -
  #done
#}



# TODO: Change directory and don't bother requiring double-quotes in the string..
#cd() {
#  # This isn't working..
#  dir=${*:gs/~/\\\\~/}
#  builtin cd "$dir"
#}
# ccd() {
# a="$@"
# \echo $a
# # b=${a:gs/ /\\\\ /}
# b=${(q)a}
# \echo $b
#   \cd $b
# }



# Find and enter the highest numbered directory
# FIXME - this doesn't work to go to 0.0.99 instead of 0.0.1
cdv() {
  if [ ! "x$1" = "x" ]; then
    # TODO: Sanity-check on $1 (a directory, exists, whatever)
    \cd "$1"
  fi
  # Translation:  Only directories | only n.n.n format | remove trailing slash.| only the last entry
  \cd $( \ls  -1  --directory */ | \grep  '[0-9]*\.[0-9]*\.[0-9]' | \sed  's/\///' | \tail  --lines=1 )
}



: << NO_WAY
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
NO_WAY



# FIXME: I don't understand why I cannot call this ls()
dir() {
  \ls \
    -1 \
    --almost-all \
    --color=always \
    --group-directories-first \
    --human-readable \
    --no-group \
    --size \
    $@  |\
      \less \
        --raw-control-chars \
        --no-init \
        --QUIT-AT-EOF \
        --quit-on-intr \
        --quiet
    ` # `
}



# A proper dir command!
# dir() { /bin/ls --color -gGh "$@"|cut -d" " -f4-100 ; }
# dir() { \ls --color -gGh "$@" | \cut -b14- | \less -F -r ; }
# Challenges:
# 1) Don't display a size for directories.
# TODO: -R does funny things.  Catch if it's been sent (even with -AR) and deal with it specially?
# Note that $LESS will influence the display.
TODO_dir() {
  if [ "x$1" = "x-d" ] || [ "x$1" = "x-ad" ]; then
    ddir
    return $?
  fi
  file_sizes=
  file_sizes_commas=
  file_sizes_width=
  ls_options="-g  --no-group  -l  --numeric-uid-gid  -v  --color  --group-directories-first  ${@}"
  # FIXME: Why is the first file size left-aligned?
  # IDEA: Only display files.  I'd have to adapt the `find` code from ddir.

  # This will sort dotfiles above regular files.  Lubuntu 10.10 .. at first I needed it and now I don't.  Hrm.
  # export LANG="C"
# FUCK, fixme - doesn't work with stuff with spaces in it, or with directories with a space in them?  Or maybe directories with not much stuff in them..
  file_sizes=$(
    \ls $ls_options \
      | \cut  --bytes=15- \
      | \cut  --delimiter="-"  --fields=1 \
      | \rev \
      | \cut  --bytes=6- \
      | \sed  --expression='s/ //g' \
      | \rev
  )
  file_sizes_commas=comma( $file_sizes )
  file_sizes_width=$(
    \ls $ls_options \
      | \cut  --bytes=15- \
      | \cut  --delimiter="-" --fields=1 \
      | \rev \
      | \cut  --bytes=6- \
      | \sed  --expression='s/ //g' \
      | \rev \
      | \sort  --general-numeric-sort \
      | \sed  --expression=:a -e 's/\(.*[0-9]\)\([0-9]\{3\}\)/\1,\2/;ta' \
      | \tail  --lines=1
  )
  file_sizes_width=${#file_sizes_width}
read -d '' file_sizes <<EOF
$(
  # Intentionally not in quotes.
  for i in $file_sizes_commas; do
    printf "%${file_sizes_width}s\n" "$i"
  done
)
EOF

  file_names=$(
    \ls $ls_options \
      | \cut  --bytes=15- \
      | \cut  --delimiter=":" --fields=2- \
      | \cut  --bytes=4- \
      | \sed  '1d'
  )
  # Yay for process substitution!  This puts the two columns side-by-side.
  \paste \
    <( \printf  '%s'  "$file_sizes" ) \
    <( \printf  '%s'  "$file_names" ) |\
      \less  --raw-control-chars  --HILITE-UNREAD  --QUIT-AT-EOF


#\echo "$new_file_sizes"
}



# DOS-style `dir /ad`
ddir() {
  OLD_LC_COLLATE="$LC_COLLATE"
  \export  LC_COLLATE=C
  if [ -z $1 ]; then
    \ls  -1  --color  --directory  *  .* | \less  --raw-control-char  --QUIT-AT-EOF

  else
    \ls  -1  --color  --directory  $*    | \less  --raw-control-char  --QUIT-AT-EOF
  fi
  \export  LC_COLLATE="$OLD_LC_COLLATE"
  OLD_LC_COLLATE=
}
alias lsd=ddir



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



# Solves commandline limitations.  Hot damn.
findqueue() {
  #local deadbeef=1
  #local debug=true

  # Case-insensitive globbing:
  \unsetopt CASE_GLOB
  # Search through directories, and read it all into an array.
  # The ending (.) means "files only".
  # Fucking son of a bitch it's impossible to make glob use a variable in a sensible way.
  #params=
  #for i in {1..${#@}}; do
    #if [ $i -gt 1 ]; then
      #params+="\ "
    #fi;
    #params+="$@[$i]"
  #done
  #\echo $params
  #\echo "$params"
  # Just brute forcing this..
  if [ -z $1 ]; then
    files_array=( ./**/**(.) )
  elif [ -z $2 ]; then
    files_array=( ./**/*$1*(.) )
  elif [ -z $3 ]; then
    files_array=( ./**/*$1\ $2*(.) )
  elif [ -z $4 ]; then
    files_array=( ./**/*$1\ $2\ $3*(.) )
  elif [ -z $5 ]; then
    files_array=( ./**/*$1\ $2\ $3\ $4*(.) )
  else
    \echo  'ERROR -----------------------------------------------------'
  fi


  # TODO:  files_array can be shuffled here.
  #        If zsh could sanely shuffle an array.  =/

  # Iterate through the array.
  # FIXME - this seems to be random!  Needs testing
  # I could take a random entry like this:
  #\echo $files_array[$RANDOM%$#FILES+1]
  if [[ x$deadbeef == x1 ]]; then
    # In my original tests, I did not need to do anything.
    #/l/OS/bin/deadbeef-0.7.2/deadbeef
  else
    \audacious  --show-main-window &
    # An unfortunate need, it seems, to prevent a billion instances from spawning.
    # TODO - Maybe I could wait for its pid?
    \sleep  1
  fi
  for i in {1..${#files_array}}; do
    if [ $debug ]; then
      \echo  "Processing:  $files_array[$i]"
    fi
    if [[ x$deadbeef == x1 ]]; then
      # FIXME - apparently  --queue  does not work any more.  Somehow.
      #\deadbeef  --queue     "$files_array[$i]" &
      #\deadbeef.sh  --queue     "$files_array[$i]"
      #\deadbeef.sh  --queue     \'"${files_array[${i}]}"\'
      \deadbeef  --queue     \'"${files_array[${i}]}"\' &
    else
      \audacious  --enqueue  "$files_array[$i]" &
    fi
    #\sleep 0.1
  done
}



# TODO - yes it's possible to rig things so that playback begins when the very first item is added, but that's a bit annoying to do.  I don't understand parameters in scripting well enough to do it cleanly.  Needing to do that reveals a big issue with the player.. perhaps it's configured to scan every file for meta data.
findplay() {
  #local deadbeef=1

  if [[ x$deadbeef == x1 ]]; then
    # Deadbeef has no functionality to just empty out its existing play list, but I can load an empty one.

:<<'DEADBEEF_EMPTY_PLAYLIST'

(
\xxd  -r  <<  'DBPL'  #  xxd
0000000: 4442 504c 0102 0000 0000 0000            DBPL........
DBPL
) > /l/deadbeef_empty_playlist.dbpl

DEADBEEF_EMPTY_PLAYLIST

    \deadbeef  /l/deadbeef_empty_playlist.dbpl
    \sleep  0.1
    findqueue  $*
    \deadbeef  --play
    #\rm  --force  $temp
    # I could just point to a random entry in deadbeef's playlist:
    #\deadbeef  --random  --play
  else
    # Audacious has no functionality to just empty out its existing play list, but I can load an empty one.  Here are three examples:

:<<'AUPL'
title=Now%20Playing
AUPL

:<<'PLS'
[playlist]
NumberOfEntries=0
PLS

:<<'XSPF'
<?xml version="1.0" encoding="UTF-8"?>
<playlist version="1" xmlns="http://xspf.org/ns/0/">
  <title>Now Playing</title>
  <trackList/>
</playlist>
XSPF

    #\audacious  --enqueue-to-temp  /l/empty_playlist.xspf &
    \sleep  0.1
    findqueue  $*
    \audacious  --play
  fi
}



# TODO - Do I actually use this anywhere?
# if a file exists, act on it.
# warning: Your command won't prompt!  (so rm will nuke files)
ifexists() {
  if [ -a "$2" ]; then
    "$1" "$2"
  fi
}



searchstring() {
  unset searchstring_success
  # TODO - I really need to stop doing this.
  until [ "sky" = "falling" ]; do
  # 2 parameters, no blanks, first parameter  must be one character.
  if [ ! "$#" -eq 2 ] || [ "$1" = "" ] || [ "$2" = "" ] || [ `expr length $1` -gt 1 ]; then \echo "Needs two parameters: a character, and a string"; break ; fi
  character="$1"
  string="$2"
  # Iterate through the string.
  for i in $( \seq  0  $( ( ${#string} - 1 ) ) ); do
    # Checking that location in the string, see if the character matches.
    # I should convert this into an 'until' so it makes sense to me, and it halts on the first success.
    if [ "${string:$i:1}" = "$character" ]; then searchstring_success=$i ; fi
  done
  if [ ! "$searchstring_success" = "" ]; then \echo $searchstring_success ; else \echo "-1" ; fi
  break
  done
}

searchstring_right_l() {
  unset searchstring_success
  # TODO - I really need to stop doing this.
  until [ "sky" = "falling" ]; do
  # 2 parameters, no blanks, first parameter  must be one character.
  if [ ! "$#" -eq 2 ] || [ "$1" = "" ] || [ "$2" = "" ] || [ $( \expr length $1 ) -gt 1 ]; then \echo "Needs two parameters: a character, and a string"; break ; fi
  character="$1"
  string="$2"

  position=0
  length=${#string}
  until [ $length = -1 ]; do
    if [ "${string:$length:1}" = "$character" ]; then searchstring_success=$length ; fi
    ((position++))
    ((length--))
  done
  if [ ! "$searchstring_success" = "" ]; then \echo $searchstring_success ; else \echo "-1" ; fi
  break
  done
}

searchstring_right_r() {
  unset searchstring_success
  until [ "sky" = "falling" ]; do
  # 2 parameters, no blanks, first parameter  must be one character.
  if [ ! "$#" -eq 2 ] || [ "$1" = "" ] || [ "$2" = "" ] || [ $( \expr length $1 ) -gt 1 ]; then \echo "Needs two parameters: a character, and a string"; break ; fi
  character="$1"
  string="$2"
  position=0
  length=${#string}
  until [ $length = -1 ]; do
    if [ "${string:$length:1}" = "$character" ]; then searchstring_success=$position ; fi
    ((position++))
    ((length--))
  done
  if [ ! "$searchstring_success" = "" ]; then \echo  $searchstring_success ; else \echo "-1" ; fi
  break
  done
}



divide() {
  # Just simple for now.  Elsewhere I have more complex code that's more thorough
  isnumber() {
    if expr $1 + 1 &> /dev/null ; then
      \echo "0"
    else
      \echo "1"
    fi
  }

  # Since "exit" also exits xterm, I do this to allow "break" to end this procedure.
  until [ "sky" = "falling" ]; do
  if [ ! "$#" -eq 2 ] || [ "$1" = "" ] || [ "$2" = "" ] ; then \echo "Needs two parameters"; break ; fi
  # FIXME - \isnumber doesn't exist on Slackware 14.1
  #         Maybe it existed in my previous Lubuntu installation, but I haven't used this in a long time.
  if [ ! $( \isnumber $1 ) -eq 0 ] || [ ! $( \isnumber $2 ) -eq 0 ] ; then \echo "Needs two numbers"; break; fi

  left=$1
  right=$2
  answer_left=$(( $left / $right ))

  # TODO: Allow a third input to specify the number of places to give (the number of 0s)
  # TODO: Or, allow notation like divide 1 2.12345 and detect the number of places after the dot.
  #   With that, I'd have to convert the string into numbers and remove the decimal for bash to work with.  Too much math for me.  =)
  # The number of 0s is the number of places displayed after the decimal.
  left=$(( $left * 100 ))
  answer_right=$(( $left / $right ))
  # clean up $answer_left from the beginning of $answer_right
  answer_right=${answer_right#*$answer_left}

  # Add a dot.  Must be combined into a variable otherwise the final echo won't work.
  \echo $answer_left"."$answer_right

break
done
}



position_from_right_to_left() {
  until [ "sky" = "falling" ]; do
  if [ ! "$#" -eq 2 ] || [ "$1" = "" ] || [ "$2" = "" ]; then \echo "Needs two parameters: a string and a number"; break ; fi
  expr $2 + 1 &> /dev/null ; result=$?
  if [ $result -ne 0 ]; then \echo $2 is not a number. ; break ; fi
  string=$1
  position=$2
  length=${#string}
  iteration=0
  until [ $length -eq $position ]; do
    ((iteration++))
    ((length--))
  done
  \echo  $iteration
  break
  done
}



insert_character() {
  unset searchstring_success
  until [ 'sky' = 'falling' ]; do
  # 2 parameters, no blanks, first parameter  must be one character.
  # I should use -z and not = ''
  if [ ! "$#" -eq 3 ] || [ "$1" = '' ] || [ "$2" = '' ] || [ "$3" = '' ] || [ $( \expr length $1 ) -gt 1 ]; then \echo  'Needs three parameters: a character, a string and a position'; break ; fi
  expr $3 + 1 &> /dev/null ; result=$?
  if [ $result -ne 0 ]; then \echo $3 is not a number. ; break ; fi
  character="$1"
  string="$2"
  position="$3"
  length=${#string}
  i=0
  unset newstring
  until [ $i -eq $length ]; do
    newstring=$newstring${string:$i:1}
    ((i++))
    if [ $i -eq $position ]; then newstring=$newstring$character ; fi
  done
  \echo  $newstring
  break
  done
}

replace_character() {
  unset searchstring_success
  until [ 'sky' = 'falling' ]; do
  # 2 parameters, no blanks, first parameter  must be one character.
  # I should use -z and not = ''
  if [ ! "$#" -eq 3 ] || [ "$1" = '' ] || [ "$2" = '' ] || [ "$3" = '' ] || [ $( \expr length $1 ) -gt 1 ]; then \echo  'Needs three parameters: a character, a string and a position'; break ; fi
  expr $3 + 1 &> /dev/null ; result=$?
  if [ $result -ne 0 ]; then \echo $3 is not a number. ; break ; fi
  character="$1"
  string="$2"
  position="$3"
  length=${#string}
  i=0
  unset newstring
  until [ $i -eq $length ]; do
    if [ $i -eq $position ]; then
      newstring=$newstring$character
    else
      newstring=$newstring${string:$i:1}
    fi
    ((i++))
  done
  \echo  $newstring

  break
  done
}



multiply() {
  until [ 'sky' = 'falling' ]; do
  # I should use -z and not = ''
    if [ ! "$#" -eq 2 ] || [ "$1" = '' ] || [ "$2" = '' ] ; then \echo  'Needs two parameters'; break ; fi
    if [ ! $( isnumber $1 ) -eq 0 ] || [ ! $( isnumber $2 ) -eq 0 ] ; then \echo  'Needs two numbers'; break; fi
    a=$1
    b=$2

    # remove the . from either.
    a_nodot=${a//./""}
    b_nodot=${b//./""}

    # Multiply the decimal-less numbers together:
    sum=$(( $a_nodot * $b_nodot ))

    # Learn the position of "." in each.
    a_dotloc=$( searchstring_right_r  '.'  $a )
    b_dotloc=$( searchstring_right_r  '.'  $b )

    # Add one to it, to get its position in human terms.
    # If there was no dot (-1) then make it 0.
    if [ $a_dotloc -gt '-1' ]; then ((a_dotloc--)) ; else a_dotloc=0 ; fi
    if [ $b_dotloc -gt '-1' ]; then ((b_dotloc--)) ; else b_dotloc=0 ; fi

    # add the two positions of '.' together
    dotloc=$(( $a_dotloc + $b_dotloc ))

    # insert "." into $sum
    # But first I must learn the proper insertion location.  Convert from from-right to the standard from-left.
    dotloc=$( position_from_right_to_left  $sum  $dotloc )

    # insert a '.' into $sum, but not at the end
    if [ $dotloc -ne ${#sum} ]; then sum=$( insert_character  '.'  "$sum"  $dotloc ) ; fi

    \echo $sum
  break
  done
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


# Note that none of this was checked in bash-windows
# FIXME - none of this would work with autocomplete, so fuck it.
# todo - This needs to be tested.
: << DISABLED_cd
# Be able to cd into the directory of a file, because autocomplete gives a filename.
cd() {
## One would think something like this would work for multiple parameters, but it doesn't.  Well fuck it, the user (me) can \cd foo bar if they want to.
#  if [ x$2 == x ]; then
#    # do nothing
#    \echo -n ''
#  else
#    \cd  $*
#    return  $!
#  fi
#
  __="$1"
  if [ -f $1 ]; then
    # delete the crap off of the trailing slash
    __=$( \dirname "$1" )
 fi
  # check that what remains is sane
  [ -d $__ ]
  if [ $! -ne 0 ]; then
    \echo  ERROR:  This is not a directory:
    \echo  $__
    return  1
  fi
  # I have no idea what -P means.  Screw you, past self.  Document more.
  # FIXME - is there a long form for -P ?  There is no  man cd
  \cd  -P  "$__"
}
DISABLED_cd



# I don't know why I had this uncommented in aliases.sh, but I'm moving it here and disabling it.
: << DISABLED_rm
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
DISABLED_rm

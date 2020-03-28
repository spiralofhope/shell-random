#!/usr/bin/env  zsh


:<<HEREDOC
If a directory of files IMG_5286.jpg to IMG_5362.jpg isn't contiguous list, fill in the gaps with note files.
(also correct filenames)


FIXME:  This was for an alternate version of rename.  The current usage is:  rename 's/before/after/' *
HEREDOC

if [ -z "$*" ]; then
  dir=001
else
  # FIXME:  Skip if $dir has no files.
  dir=$1
fi

# --

_setup(){
  \cd  "$dir"  ||  return  $?
}

_get_start(){
  #start=$(  \ls -1 | \head -n 1  )
  # FIXME - replace with shism
  start=$(  \find . -maxdepth 1 | \head -n 1  )
  start[1,4]=''
  start[5,-1]=''
}

_get_end(){
  #end=$(  \ls -1 | \tail -n 1  )
  # FIXME - replace with shism
  end=$(  \find . -maxdepth 1 | \tail -n 1  )
  end[1,4]=''
  end[5,-1]=''
}

_check_names(){
  # Meh, why bother being smart about it.
  \rename img IMG ./*
  # FIXME:  I don't know how to report if a change would be or was made.
  #         This doesn't work:
  #if [ $? -ne 0 ]; then
    #\echo Corrected files in $dir
  #fi
  \rename Img IMG ./*
  \rename 'IMG ' 'IMG_' ./*
}

# FIXME:  This can't deal with directories.
_find_missing_pictures(){
  found_missing=0
  # likely a zshism
  # shellcheck disable=2128
  loop_start="$start"
  # likely a zshism
  # shellcheck disable=2128
  loop_stop="$end"
  while [ "$loop_start" -le "$loop_stop" ]; do
    #\echo  "$loop_start"
    f="IMG_${loop_start}.jpg"
    if [ -f "$f" ]; then  return;  fi
    # zshism
    # shellcheck disable=1087
    # shellcheck disable=2125
    # shellcheck disable=2128
    recheck=$f[1,8]                  # IMG_1234xx => IMG_1234
    if  !  \
      \ls "$recheck*"  > /dev/null  2> /dev/null
    then
      \echo "Couldn't find $dir/$f"
      # Create a filler file.
      f="${f} - missing"
      :>"$f"
      found_missing=1
    fi
    loop_start=$(( loop_start + 1 ))
  done
}


_teardown(){
  \cd  -  ||  return  $?
  if [ $found_missing -ne 0 ]; then
    \mv  "$dir" "${dir} - partial"  ||  return  $?
  fi
}

# --

_setup
_get_start
_get_end
_check_names
_find_missing_pictures
_teardown


\cd  -  ||  return  $?


#:<<'}'   #  Working on a more difficult way..
{
\zmodload zsh/mathfunc

# FIXME - replace with shism
#actual=$( ls -1 | wc -l )
actual=$( \find  .  -maxdepth 1  |  \wc -l )
# placeholder
total=1
actual=$(( total - 1 ))
\echo  "$total"

#start=$( ls -1 | head -n 1 )
# FIXME - replace with shism
# likely a zshism
# shellcheck disable=2178
start=$( \find  .  -maxdepth 1  |  \head -n 1 )
start[1,4]=''
start[-4,-1]=''

# FIXME - replace with shism
#end=$( ls -1 | tail -n 1 )
# likely a zshism
# shellcheck disable=2178
end=$( \find  .  -maxdepth 1  |  tail -n 1 )
end[1,4]=''
end[-4,-1]=''

expected=$(( end - start - 1 ))

if [ $expected -ne $actual ]; then
  \echo "expected " $expected
  \echo "     got " $actual
  if [ $expected -gt $actual ]; then
    \echo  ''
    # likely a zshism
    # shellcheck disable=2128
    loop_start="$start"
    # likely a zshism
    # shellcheck disable=2128
    loop_stop="$end"
    while [ "$loop_start" -le $loop_stop ]; do
      # shellcheck disable=1117
      #\echo  "$loop_start"
      f="IMG_${loop_start}.jpg"
      if ! [ -f "$f" ]; then
        # shellcheck disable=1117
        \echo  "$f not found."
      fi
      loop_start=$(( loop_start + 1 ))
    done
  fi

fi
}

#!/bin/env zsh

:<<HEREDOC
If a directory of files IMG_5286.jpg to IMG_5362.jpg isn't contiguous list, fill in the gaps with note files.
(also correct filenames)


FIXME:  This was for an alternate version of rename.  The current usage is:  rename 's/before/after/' *
HEREDOC

if [ -z $1 ]; then
  dir=001
else
  # FIXME:  Skip if $dir has no files.
  dir=$1
fi

# --

_setup(){
  \cd "$dir"
}

_get_start(){
  start=`ls -1 | head -n 1`
  start[1,4]=''
  start[5,-1]=''
}

_get_end(){
  end=`ls -1 | tail -n 1`
  end[1,4]=''
  end[5,-1]=''
}

_check_names(){
  # Meh, why bother being smart about it.
  \rename img IMG *
  # FIXME:  I don't know how to report if a change would be or was made.
  #         This doesn't work:
  #if [ $? -ne 0 ]; then
    #\echo Corrected files in $dir
  #fi
  \rename Img IMG *
  \rename 'IMG ' 'IMG_' *
}

# FIXME:  This can't deal with directories.
_find_missing_pictures(){
  found_missing=0
  for i in {$start..$end}; do
    \local f=IMG_${i}.jpg
    if ! [ -f $f ]; then
      \local recheck=$f[1,8]                  # IMG_1234xx => IMG_1234
      # FIXME:  I can't make this local.  There's a better way for this crap, which I've done elsewhere..
      a=`\ls $recheck*` &> /dev/null
      if [ $? -eq 1 ]; then
        \echo "Couldn't find" $dir/$f
        # Create a filler file.
        \local f="${f} - missing"
        \touch $f
        found_missing=1
      fi
      \unset 1
    fi
  done
  \unset i
}

_teardown(){
  \cd -
  if [ $found_missing -ne 0 ]; then
    \mv "$dir" "${dir} - partial"
  fi
}

# --

_setup
_get_start
_get_end
_check_names
_find_missing_pictures
_teardown


\cd -


:<<HEREDOC
Working on a more difficult way..


\zmodload zsh/mathfunc

actual=`ls -1 | wc -l`
actual=$(( $total - 1 ))

start=`ls -1 | head -n 1`
start[1,4]=''
start[-4,-1]=''

end=`ls -1 | tail -n 1`
end[1,4]=''
end[-4,-1]=''

expected=$(( $end - $start - 1 ))

if [[ $expected -ne $actual ]]; then
  \echo "expected " $expected
  \echo "     got " $actual
  if [[ $expected -gt $actual ]]; then
    \echo;
    for i in {$start..$end}; do
      f=IMG_${i}.jpg
      if ! [ -f $f ]; then
        echo $f not found.
      fi
    done
  fi

fi
HEREDOC
#!/usr/bin/env  sh
# Helper tools to queue or play media from the commandline.



# Note that deadbeef probably isn't installed, and will need a manual symlink in  $HOME/l/path  pointing to its executable.
\which  deadbeef  >  /dev/null
#false   #  Un-comment to trigger the fallback (audacious).
if [ $? -eq 0 ]; then
  local  deadbeef_is_installed=true
else
  local  deadbeef_is_installed=false
fi



:<<'}'   #  old, for testing purposes
# TODO - shouldn't there be an audacious version?
fq() {
  \find  .  -iname "*$1*"  -type f  -print0  |\
    \xargs  \
      --null  \
      "$( \which deadbeef )"  \
        --queue "{}"  \
      > /dev/null 2> /dev/null &
}




if [ "$deadbeef_is_installed" = 'true' ]; then                     {   #  Deadbeef

findqueue() {

  \echo  ' * Launching deadbeef..'
  # For reasons unknown, a symlink will not work.  Directly using  `which`  solves that.
  \setsid  $( \which deadbeef )  > /dev/null 2> /dev/null  &
  until pids=$( \pidof  "$( \which deadbeef )" ); do   
    \echo  ' * .. waiting'
    \ps  alx | \grep  "$( \which deadbeef )"
    \sleep  0.1
  done


  local  _queue() {

    local  extension="$1"
    shift
    local  iname="*${@}${extension}"
    \echo  "Searching for:  $iname"
    #\find  .  -type f  -iname "$iname"

    # I don't like using  --verbose  so this will do:
    \find  .  -type f  -iname "$iname"  -print0  |\
      \xargs  \
      --no-run-if-empty  \
      --null  \
      -I file  \
      \echo  file

    \find  .  -type f  -iname "$iname"  -print0  |\
      \xargs  \
        --no-run-if-empty  \
        --null  \
        -I file  \
        'deadbeef'  \
          --queue file  \
        > /dev/null 2> /dev/null
  }

  # TODO - As deadbeef empties a playlist once it hits an invalid file, I'm going over its more common file types manually.
  # This might blank the playlist, but format is supported.  It's something being offered into the queue that's blanking it.  This was reproduced with a ։ in the filename.
  #   Therefore I'll put this first, so it won't be so awful if it's triggered.
  _queue  'm4a'  "$@"
  _queue  'mp3'  "$@"
  _queue  'ogg'  "$@"
  _queue  'flac' "$@"
  _queue  'opus' "$@"
  ## Oldschool, via plugins
  _queue  'sid'  "$@"
  # TODO - more extensions
  
}

}  else                                                             {   #  Audacious

findqueue() {
  \echo  ' * Launching audacious..'
  \setsid  \audacious  --show-main-window  > /dev/null 2> /dev/null  &
  until pids=$( \pidof  'audacious' ); do   
    \echo  ' * .. waiting'
    \ps  alx | \grep  'audacious'
    \sleep  0.1
  done
  # sleep 1

  # I don't like using  --verbose  so this will do:
  \find  .  -type f  -iname "*${*}*"  -print0  |\
    \xargs  \
      --no-run-if-empty  \
      --null  \
      -I file  \
      \echo  file

  \find  .  -type f  -iname "*${*}*"  -print0  |\
    \xargs  \
      --no-run-if-empty  \
      --null  \
      -I file  \
      \audacious  \
        --enqueue  file  \
      > /dev/null 2> /dev/null
}

}  fi








if [ "$deadbeef_is_installed" = 'true' ]; then                     {   #  Deadbeef

findplay() {

  {  #  Make a Deadbeef empty playlist
  # Deadbeef has no functionality to just empty out its existing play list, but I can load an empty one.
  local  tempfile=$( \mktemp  --suffix="--deadbeef-empty-playlist.dbpl" )
(  #  It was a binary, so I encoded it with xxd
\xxd  -r  <<  'DBPL'
0000000: 4442 504c 0102 0000 0000 0000            DBPL........
DBPL
) > "$tempfile"
  }

  {  # Launch

    # Make sure it's running first.
    # For reasons unknown, a symlink will not work.  Directly using  `which`  solves that.
    \setsid  $( \which deadbeef "$tempfile" )  > /dev/null 2> /dev/null  &
    # Wait for it to launch
    until pids=$( \pidof  "$( \which deadbeef )" ); do   
      \echo  ' * Waiting for deadbeef to launch..'
      \ps  alx | \grep  "$( \which deadbeef )"
      \sleep  0.1
    done

  }
    
  {  # Queue
    findqueue  $*
  }
  
  {  #  Play
    \deadbeef  --play
    # BUG:  It plays the second song in the now-populated playlist.
    #   Workaround:
    \deadbeef  --prev
  }

  {  # Teardown
    \rm   --force  --verbose  "$tempfile"
  }

}

}  else                                                             {   #  Audacious

findplay() {

  {  #  Make an Audacious empty playlist
    # Audacious has no functionality to just empty out its existing play list, but I can load an empty one.  Here are three examples:

:<<'AUPL'
title=Now%20Playing
AUPL
#  .pls
:<<'PLS'
[playlist]
NumberOfEntries=0
PLS
#
:<<'XSPF'
<?xml version="1.0" encoding="UTF-8"?>
<playlist version="1" xmlns="http://xspf.org/ns/0/">
  <title>Now Playing</title>
  <trackList/>
</playlist>
XSPF
#  .asx
:<<'ASXv3'
<?xml version="1.0" encoding="UTF-8"?>
<asx version="3.0">
  <title>Now Playing</title>
</asx>
ASXv3

    # ASX seems nice.
    local  tempfile=$( \mktemp  --suffix="--audacious-empty-playlist.asx" )
    \echo  'making tempfile: ' $tempfile
(\cat << 'audacious-empty-playlist'
<?xml version="1.0" encoding="UTF-8"?>
<asx version="3.0">
  <title>Now Playing</title>
</asx>
audacious-empty-playlist
) >> "$tempfile"
#less "$tempfile"

  }

  {  # Launch with the empty playlist
    \audacious  --enqueue-to-temp  "$tempfile"  > /dev/null 2> /dev/null  &
    until pids=$( \pidof  'audacious' ); do   
      echo  'waiting for audacious to launch..'
      \ps  alx | \grep  'audacious'
      \sleep  0.1
    done
    \sleep  1
  }

  {  # Queue
    findqueue  $*
  }

  {  # Play
    \audacious  --play
  }

  {  # Teardown
    \rm   --force  --verbose  "$tempfile"
  }

}

}  fi

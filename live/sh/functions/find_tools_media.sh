#!/usr/bin/env  sh
# shellcheck disable=1001
# Helper tools to queue or play media from the commandline.



# Note that DeaDBeeF probably isn't installed like a proper application (because of a joke license), and will need a manual symlink in a $PATH  (I use $HOME/l/path)  which points to its executable.
if  \
  \command  -v deadbeef  2>  /dev/null
  #false   #  Un-comment to trigger the fallback (audacious).
then
  deadbeef_is_installed=true
else
  deadbeef_is_installed=false
fi



:<<'}'   #  old, for testing purposes
# TODO - shouldn't there be an audacious version?
fq() {
  \find  .  -iname "*$1*"  -type f  -print0  |\
    \xargs  \
      --null  \
      "$( \realpath  deadbeef )"  \
        --queue "{}"  \
      > /dev/null 2> /dev/null &
}



:<<'}   # /findqueue'
{
if [ "$deadbeef_is_installed" = 'true' ]; then                     {   #  Deadbeef

findqueue() {
  # Note that the current playlist is:  "$HOME/.config/deadbeef/playlists/0.dbpl"
  \echo  ' * Launching DeaDBeeF..'
  \setsid  "$( \realpath  deadbeef )"  > /dev/null 2> /dev/null  &
  # Wait for it to launch
  until  \
    \pidof  'deadbeef'
  do
    \echo  ' * .. waiting'
    \sleep  0.1
  done


  _queue() {
    extension="$1"
    shift
    iname="*${*}${extension}"
    \echo  "Searching for:  $iname"
    #\find  .  -type f  -iname "$iname"
    #
    # I don't like using  --verbose  so this will do:
    \find  .  -type f  -iname "$iname"  -print0  |\
      \xargs  \
      --no-run-if-empty  \
      --null  \
      -I file  \
      \echo  file
    #
    \find  .  -type f  -iname "$iname"  -print0  |\
      \xargs  \
        --no-run-if-empty  \
        --null  \
        -I file  \
        'deadbeef'  \
          --queue file  \
        > /dev/null 2> /dev/null
  }

  # TODO - As DeaDBeeF empties a playlist once it hits an invalid file, I'm going over its more common file types manually.
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
  # Wait for it to launch
  until
    \pidof  'audacious'
  do
    \echo  ' * .. waiting'
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
}   # /findqueue






#:<<'}   # /findplay'
{
if [ "$deadbeef_is_installed" = 'true' ]; then                     {   #  DeaDBeeF

findplay() {

  #:<<'  }'   #  Make a DeaDBeeF empty playlist
  {
    # DeaDBeeF has no functionality to just empty out its existing play list, but I can load an empty one.
    temporary_playlist=$( \mktemp  --suffix="--deadbeef-empty-playlist.dbpl" )
    # As of DeaDBeeF 1.8.2 this doesn't actually work..
(  #  It was a binary, so I encoded it with xxd
\xxd  -r  <<  'DBPL'
00000000: 4442 504c 0102 0000 0000 0000            DBPL........
DBPL
) >> "$temporary_playlist"
    # Note that DeaDBeeF 0.7.2 had an empty playlist with one less 0
    #0000000: 4442 504c 0102 0000 0000 0000            DBPL........
  }
#less  "$temporary_playlist"

\cp  --force  ~/untitled.dbpl  "$temporary_playlist"

  #:<<'  }'   #  Launch
  {
    # Make sure it's running first.
    # shellcheck disable=1012
    \setsid  "$( \realpath  deadbeef )"  "$temporary_playlist"  > /dev/null 2> /dev/null  &
    # Wait for it to launch
    until
      \pidof  'deadbeef'
    do
      \echo  ' * Waiting for DeaDBeeF to launch..'
      \sleep  0.1
    done
  }
    
  #:<<'  }'   #  Queue
  {
    findqueue  "$*"
  }
  
  #:<<'  }'   #  Play
  {
    \deadbeef  --play
    # BUG:  It plays the second song in the now-populated playlist.
    #   Workaround:
    \deadbeef  --prev
  }

  #:<<'  }'   #  Teardown
  {
    # shellcheck disable=1012
    \rm   --force  --verbose  "$temporary_playlist"
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
    temporary_playlist=$( \mktemp  --suffix="--audacious-empty-playlist.asx" )
    \echo  "making temporary playlist:  $temporary_playlist"
(\cat << 'audacious-empty-playlist'
<?xml version="1.0" encoding="UTF-8"?>
<asx version="3.0">
  <title>Now Playing</title>
</asx>
audacious-empty-playlist
) >> "$temporary_playlist"
#less "$temporary_playlist"

  }

  #:<<'  }'   #  Launch with the empty playlist
  {
    \audacious  --enqueue-to-temp  "$temporary_playlist"  > /dev/null 2> /dev/null  &
    # Wait for it to launch
    until
      \pidof  'audacious'
    do
      echo  'waiting for audacious to launch..'
      \sleep  0.1
    done
    #\sleep  1
  }

  #:<<'  }'   #  Queue
  {
    findqueue  "$*"
  }

  #:<<'  }'   #  Play
  {
    \audacious  --play
  }

  #:<<'  }'   #  Teardown
  {
    # shellcheck disable=1012
    \rm   --force  --verbose  "$temporary_playlist"
  }

}

}  fi
}   # /findplay

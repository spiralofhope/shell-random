# TODO - Just check for deadbeef and use it by default?
#local  deadbeef=1
local  deadbeef=0



# TODO - shouldn't there be an audacious version?
fq() {
  \find  .  -iname "*$1*"  -type f  -print0  |\
    \xargs  \
      --null  \
      '/l/OS/bin/deadbeef-0.7.2/deadbeef'  \
        --queue "{}"  \
      > /dev/null 2> /dev/null &
}




if [[ x$deadbeef == x1 ]]; then                                     {   #  Deadbeef

findqueue() {
  ## Make sure it's running first.
  #\setsid  '/l/OS/bin/deadbeef-0.7.2/deadbeef'  > /dev/null 2> /dev/null  &
  ## Wait for it to launch
  #until pids=$( \pidof  '/l/OS/bin/deadbeef-0.7.2/deadbeef' ); do
    ##\ps | \grep  'deadbeef-gtkui$'
    #\sleep  0.1
  #done

  local _queue() {
    local  extension="$1"
    shift
    local  iname="*${@}*${extension}"
    \echo  "Searching for:  $iname"
    #\find  .  -type f  -iname "$iname"

    \find  .  -type f  -iname "$iname"  -print0  |\
        \xargs  \
        --no-run-if-empty  \
        --null  \
        -I file  \
        '/l/OS/bin/deadbeef-0.7.2/deadbeef'  \
          --queue file  \
        > /dev/null 2> /dev/null
    \waitpid  $!

  }

  # TODO - As deadbeef empties a playlist once it hits an invalid file, I'm going over its more common file types manually.
  _queue  '.mp3'  "$@"
  _queue  '.ogg'  "$@"
  _queue  '.flac' "$@"
  _queue  '.m4a'  "$@"
  # Oldschool, via plugins
  _queue  '.sid'  "$@"
  # FIXME - more extensions

}

}  else                                                             {   #  Audacious

findqueue() {
  # Make sure it's running first.
  \setsid  \audacious  --show-main-window  > /dev/null 2> /dev/null  &
  # Wait for it to launch
  until pids=$( \pidof  'audacious' ); do   
    echo  'waiting for audacious to launch..'
    \ps  alx | \grep  'audacious'
    \sleep  0.1
  done
  # sleep 1

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








if [[ x$deadbeef == x1 ]]; then                                     {   #  Deadbeef

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

  {  # Launch with the empty playlist
    \setsid  '/l/OS/bin/deadbeef-0.7.2/deadbeef'  "$tempfile"   > /dev/null 2> /dev/null  &
    # Wait for it to launch
    until pids=$( \pidof  '/l/OS/bin/deadbeef-0.7.2/deadbeef' ) ; do
      #\ps  alx | \grep  'deadbeef' | \grep  -v  'grep deadbeef'
      # I think this will work.
      \ps  alx | \grep  -E '.* deadbeef$'

      \sleep  0.1
    done
  }
    
  {  # Queue
    findqueue $*
  }
  
  {  #  Play
    '/l/OS/bin/deadbeef-0.7.2/deadbeef'  --play
    # If findplay() is run without deadbeef already running, if it begins playing at all, then it begins playing at the second item!
    # .. so force it.
    # .. which doesn't really work..
    '/l/OS/bin/deadbeef-0.7.2/deadbeef'  --prev
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
      #\audacious  --enqueue-to-temp  /tmp/ASXv3.asx    > /dev/null 2> /dev/null  &
      \audacious  --enqueue-to-temp  "$tempfile"  > /dev/null 2> /dev/null  &
    #  Why in the everloving fuck doesn't this work?
    until pids=$( \pidof  'audacious' ); do   
      echo  'waiting for audacious to launch..'
      \ps  alx | \grep  'audacious'
      \sleep  0.1
    done
    \sleep  1
  }

  {  # Queue
    findqueue $*
  }

  {  # Play
    # FIXME - this no longer works..
    \audacious  --play
  }

  {  # Teardown
    \rm   --force  --verbose  "$tempfile"
  }

}

}  fi

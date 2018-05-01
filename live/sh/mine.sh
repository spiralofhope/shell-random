#!/usr/bin/env  sh



fq() {
  # This will empty the playlist:
  #/l/OS/bin/deadbeef-0.7.2/deadbeef  '/l/deadbeef_empty_playlist.dbpl'
  \find  .  -iname "*$1*"  -type f  -print0 |\
    \xargs  -0  \
    /l/OS/bin/deadbeef-0.7.2/deadbeef  --queue "{}"  > /dev/null 2> /dev/null &
}



fbpanel_restart(){
  \killall  fbpanel  &&  \fbpanel &
  #\sleep  2
  #\fbpanel &
  #\sleep  2
  \exit
}


# FIXME: I don't understand why I cannot call this ls()
dir() {
  \ls \
    -1 \
    --almost-all \
    --color=always \
    --group-directories-first \
    --no-group \
    --quoting-style=shell \
    --size \
    "$@"  |\
      \less \
        --raw-control-chars \
        --no-init \
        --QUIT-AT-EOF \
        --quit-on-intr \
        --quiet
    ` # `
}


findfile() {
  if [[ -d $1 ]]; then
    ${shell_random}/live/sh/scripts/findhelper.sh  file      $*
  else
    ${shell_random}/live/sh/scripts/findhelper.sh  file  ./  $*
  fi
}


finddir() {
  if [[ -d $1 ]]; then
    ${shell_random}/live/sh/scripts/findhelper.sh  directory      $*
  else
    ${shell_random}/live/sh/scripts/findhelper.sh  directory  ./  $*
  fi
}


# TODO - Technically I could make a `findin` that applies to only one file, but I won't bother.
findinall() {
  if [[ -d $1 ]]; then
    ${shell_random}/live/sh/scripts/findhelper.sh  999            $*
  else
    ${shell_random}/live/sh/scripts/findhelper.sh  999        ./  $*
  fi
}


# TODO - Technically I could make a `findin` that applies to only one file, but I won't bother.
findhere() {
  if [[ -d $1 ]]; then
    ${shell_random}/live/sh/scripts/findhelper.sh  1              $*
  else
    ${shell_random}/live/sh/scripts/findhelper.sh  1          ./  $*
  fi
}


# Make and change into a directory:
mcd() {
  \mkdir  "$1" &&\
  \cd  "$1"
}


# This used to have  --exclude-type supermount
#alias  df='\df  --human-readable'
_df_sorted(){
  _df() {
    \df  --human-readable  --exclude-type tmpfs  --exclude-type devtmpfs
  }
  # The text at the top
  _df |\
    \head --lines=1
  # The actual list of stuff
  _df |\
    \tail --lines=+2  |\
    \sort --key=${1}
}



findqueue() {
  local  deadbeef=1

  if [[ x$deadbeef == x1 ]]; then                                         {   #  Deadbeef
    # Make sure it's running first.
    \setsid  '/l/OS/bin/deadbeef-0.7.2/deadbeef'  > /dev/null 2> /dev/null  &
    # Wait for it to launch
    until pids=$( \pidof  '/l/OS/bin/deadbeef-0.7.2/deadbeef' ); do
      \ps  alx | \grep  'deadbeef'
      \sleep  0.1
    done
    find  .  -type f -iname "*${*}*" -print0 |\
      \xargs -0 -r -I file '/l/OS/bin/deadbeef-0.7.2/deadbeef'  --queue  file  > /dev/null 2> /dev/null  &
  }
  else                                                                    {   #  Audacious
    # Make sure it's running first.
    \setsid  \audacious  --show-main-window  > /dev/null 2> /dev/null  &
    # Wait for it to launch
:<<'}'   #  Why in the everloving fuck doesn't this work?
    until pids=$( \pidof  'audacious' ); do   
      echo  'waiting for audacious to launch..'
      \ps  alx | \grep  'audacious'
      \sleep  0.1
    done
}
    \sleep 1
      \ps  alx | \grep  'audacious'
      \pidof  'audacious'

    find  .  -type f -iname "*${*}*" -print0 |\
      \xargs -0 -r -I file audacious  --enqueue  file
  }
  fi
}


findplay() {
  local  deadbeef=1

  # TODO - Create the empty playlists in /l if they don't exist.
  # TODO - perform the search once, then take the first result and play with that.  Then take the rest and queue it up.
  # TODO - With with a separate 'findqueue' playlist.
          # Remove any 'findqueue' playlist
          # Create a new 'findqueue' playlist with these results.
          # Play that playlist.

  if [[ x$deadbeef == x1 ]]; then                                         {   #  Deadbeef
    # Launch with an empty playlist
    \setsid  '/l/OS/bin/deadbeef-0.7.2/deadbeef'  '/l/deadbeef_empty_playlist.dbpl'   > /dev/null 2> /dev/null  &
    # Wait for it to launch
    until pids=$( \pidof  '/l/OS/bin/deadbeef-0.7.2/deadbeef' ) ; do
      \ps  alx | \grep  'deadbeef'
      \sleep  0.1
    done
    # Queue
    find  .  -type f -iname "*${*}*" -print0 |\
      \xargs -0 -r -I file '/l/OS/bin/deadbeef-0.7.2/deadbeef'  --queue  file  > /dev/null 2> /dev/null  &
    # Play
    # FIXME - This doesn't always trigger
            # .. unless I pause for a bit.
            # .. but if I do pause, then sometimes it will play, and then restart playing.
    #\sleep  1
    # If findplay() is run without deadbeef already running, if it begins playing at all, then it begins playing at the second item!
    '/l/OS/bin/deadbeef-0.7.2/deadbeef'  --play
  }
  else                                                                    {   #  Audacious

    # Empty any current playlist:
    \setsid  \audacious  --enqueue-to-temp  /l/empty_playlist.xspf   > /dev/null 2> /dev/null  &
:<<'}'   #  Why in the everloving fuck doesn't this work?
    until pids=$( \pidof  'audacious' ); do   
      echo  'waiting for audacious to launch..'
      \ps  alx | \grep  'audacious'
      \sleep  0.1
    done
}
    \sleep  1
    # Queue
    # Pulled from findqueue()
    find  .  -type f -iname "*${*}*" -print0 |\
      \xargs -0 -r -I file audacious  --enqueue  file
    # Play
    \audacious  --play
  }
  fi



# Deadbeef has no functionality to just empty out its existing play list, but I can load an empty one.

:<<'DEADBEEF_EMPTY_PLAYLIST'

(
\xxd  -r  <<  'DBPL'  #  xxd
0000000: 4442 504c 0102 0000 0000 0000            DBPL........
DBPL
) > /l/deadbeef_empty_playlist.dbpl

DEADBEEF_EMPTY_PLAYLIST


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

}

#!/usr/bin/env  sh
# shellcheck disable=1001
#   Don't complain about my use of a backslash ( \ )

# Helper tools to queue or play media from the commandline.
# TODO - Windows support.  Search for ~~~



#  Distinguish between:
#    Cygwin
#    Linux
#    Windows Subsystem for Linux
case "$( \uname  --kernel-name )" in
  # Cygwin / Babun
  CYGWIN*)
    this_kernel_release='Cygwin'
  ;;
  # This might be okay for git-bash
  'Linux')
    case "$( \uname  --kernel-release )" in
      *-Microsoft)
        this_kernel_release='Windows Subsystem for Linux'
      ;;
      *)
        this_kernel_release='Linux'
      ;;
    esac
  ;;
  *)
    \echo  " * No scripting has been made for:  $( \uname  --kernel-name )"
  ;;
esac



# Note that DeaDBeeF probably isn't installed like a proper application (because of a joke license), and will need a manual symlink in a $PATH  (I use $HOME/l/path)  which points to its executable.
if    command  -v  \deadbeef   > /dev/null                                  ; then  program='deadbeef'
elif  command  -v  \audacious  > /dev/null                                  ; then  program='audacious'
elif  [ "$this_kernel_release" = 'Windows Subsystem for Linux' ]            ; then
  # TODO - Handle other VLC installation locations.
  if  command  -v  /mnt/c/Program\ Files/VideoLAN/VLC/vlc.exe  > /dev/null  ; then  program='vlc'
  # TODO - Implement other media programs.
  fi
else                                                                                program='unset'
fi
#program='deadbeef'
program='audacious'
#program='vlc'
#program='unset'



#:<<'}   # /findqueue'
{
if   [ "$program" = 'deadbeef'  ]; then
  findqueue() {
    # Note that the current playlist is:  "$HOME/.config/deadbeef/playlists/0.dbpl"
    \echo  ' * Launching DeaDBeeF..'
    # shellcheck disable=1012
    \setsid  deadbeef  > /dev/null 2> /dev/null  &
    until
      \pidof  'deadbeef'
    do
      \echo  ' * Waiting for DeaDBeeF..'
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
      \find  \
        .  \
        -type f  \
        -iname "$iname"  \
        ! -name '*.txt'  \
        -print0  \
        |  \
        \xargs  \
        --no-run-if-empty  \
        --null  \
        -I file  \
        \echo  file
      #
      \find  \
        .  \
        -type f  \
        -iname "$iname"  \
        ! -name '*.txt'  \
        -print0  \
        |  \
        \xargs  \
          --no-run-if-empty  \
          --null  \
          -I file  \
          'deadbeef'  \
            --queue file  \
          > /dev/null 2> /dev/null
    }


:<<'# PER_EXTENSION'
    # DeaDBeeF 0.7.2 empties a playlist once it hits an invalid file. (like a .txt or a song at 48 kHz)
    # I'm going over its more common file types manually.
    # This might blank the playlist, but format is supported.  It's something being offered into the queue that's blanking it.  This was reproduced with a ։ in the filename (that is not a colon).
    #   Therefore I'll put this first, so it won't be so awful if it's triggered.
    _queue  '*.aac'  "$@"
    _queue  '*.flac' "$@"
    _queue  '*.m4a'  "$@"
    _queue  '*.mp3'  "$@"
    _queue  '*.oga'  "$@"
    _queue  '*.ogg'  "$@"
    _queue  '*.opus' "$@"
    _queue  '*.wma'  "$@"
    ## Oldschool, via plugins
    _queue  '*.sid'  "$@"
    # TODO - more extensions
# PER_EXTENSION

    # The above is not necessary for 1.8.3 on Debian 10.1.0-amd64-xfce-CD-1
    _queue  '*'  "$@"

  }
elif [ "$program" = 'audacious' ]; then
  findqueue() {
    \echo  ' * Launching audacious..'
    \setsid  \audacious  --show-main-window  > /dev/null 2> /dev/null  &
    until
      \pidof  'audacious'
    do
      \echo  ' * Waiting for audacious..'
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
elif [ "$program" = 'vlc' ]; then
  findqueue() {
    #\echo  ' * Launching vlc..'
    #\setsid  /mnt/c/Program\ Files/VideoLAN/VLC/vlc.exe  --no-loop  > /dev/null 2> /dev/null  &
    #until
      #_=$( \pgrep  'vlc.exe' )
    #do
      #\echo  ' * Waiting for vlc..'
      #\sleep  0.1
    #done

     #Build
     #I don't like using  --verbose  so this will do:
    \find  .  -type f  -iname "*${*}*"  -print0  |\
      \xargs  \
        --no-run-if-empty  \
        --null  \
        -I file  \
        \echo  file



    #\find  .  -type f  -iname "*${*}*"  -execdir  /mnt/c/Program\ Files/VideoLAN/VLC/vlc.exe  "$( {} | \cut -c3- )"  \;
    #\find  .  -type f  -iname "*${*}*"  -print0  |\
      #\xargs  \
        #--no-run-if-empty  \
        #--null  \
        #-I file  \
        #/mnt/c/Program\ Files/VideoLAN/VLC/vlc.exe  file  \
        #> /dev/null 2> /dev/null


    #\find  .  -type f  -iname "*${*}*"  -execdir  /mnt/c/Program\ Files/VideoLAN/VLC/vlc.exe  "$( \basename  {} | \cut -c3- )"  > /dev/null 2> /dev/null  \;
    #\find  .  -type f  -iname "*${*}*"  -execdir  /mnt/c/Program\ Files/VideoLAN/VLC/vlc.exe  "$( \basename  {} | \cut -c3- )"  \;



  #\find  .  -type f  -iname *spider*  -exec  sh -c 'cd "$( dirname "{}" | cut -c3-; )" ; ls "$( basename "{}" )"'  \;
  #\find  .  -type f  -iname *spider*  -exec  sh -c 'cd "$( dirname "{}" )" ; /mnt/c/Program\ Files/VideoLAN/VLC/vlc.exe "$( basename "{}" )"'  \;
  #\find  .  -type f  -iname *spider*  -exec  sh -c 'cd "$( dirname "{}" )" ; /mnt/c/Program\ Files/VideoLAN/VLC/vlc.exe "$( basename "{}" )" &'  \;
  #\find  .  -type f  -iname *spider*  -exec  sh -c 'cd "$( dirname "{}" )" ; /mnt/c/Program\ Files/VideoLAN/VLC/vlc.exe "$( basename "{}" )" > /dev/null 2> /dev/null &'  \;



    temporary_playlist_source=$( \mktemp  --suffix="--vlc-files-list_source.txt" )
    temporary_playlist_target=$( \mktemp  --suffix="--vlc-files-list_target.txt" )

    \find  .  -type f  -iname "*${*}*"  -print0  |\
      \xargs  \
        --no-run-if-empty  \
        --null  \
        -I file  \
        \echo  file  >>  "$temporary_playlist_source"

    while  read  -r  line ; do
      \echo  " * Processing $line"
      #/mnt/c/Program\ Files/VideoLAN/VLC/vlc.exe  $( \wslpath $line ) > 
      #/mnt/c/Program\ Files/VideoLAN/VLC/vlc.exe  $( \wslpath $line ) > /dev/null 2> /dev/null &
      #echo  /mnt/c/Program\ Files/VideoLAN/VLC/vlc.exe  $( \wslpath  -w  "$( realpath "$line" )" )
      #echo  \"/mnt/c/Program\ Files/VideoLAN/VLC/vlc.exe\"  \"$( \wslpath  -w  "$line" )\"
      #/mnt/c/Program\ Files/VideoLAN/VLC/vlc.exe  $( \wslpath  -w  "$line" )
      
      # TODO - Convert it into an actual playlist
      # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    done < "$temporary_playlist_source"


    \more  "$temporary_playlist_source"
    \more  "$temporary_playlist_target"
    # shellcheck disable=1012
    \rm   --force  --verbose  "$temporary_playlist_source"
    # shellcheck disable=1012
    \rm   --force  --verbose  "$temporary_playlist_target"

 

    # Play
    # (It automatically begins playing)
  }
else
  findqueue() {
    \echo  'Error:  No media application has been found/set.'
    return  1
  }
fi
}   # /findqueue





#:<<'}   # /findplay'
{
if   [ "$program" = 'deadbeef'  ]; then
  findplay() {
    {  #  Make a DeaDBeeF empty playlist'
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
    #less  "$temporary_playlist"
    \cp  --force  ~/untitled.dbpl  "$temporary_playlist"
    }

    {  #  Launch
    # Make sure it's running first.
    \echo  ' * Launching DeaDBeeF..'
    # shellcheck disable=1012
    \setsid  deadbeef  "$temporary_playlist"  > /dev/null 2> /dev/null  &
    until
      \pidof  'deadbeef'
    do
    \echo  ' * Waiting for DeaDBeeF..'
      \sleep  0.1
    done
    }
      
    
    {  #  Queue
    findqueue  "$*"
    }
    
    {  #  Play
    \deadbeef  --play
    # BUG:  It plays the second song in the now-populated playlist.
    #   Workaround:
    \deadbeef  --prev
    }

    {  #  Teardown
    # shellcheck disable=1012
    \rm   --force  --verbose  "$temporary_playlist"
    }
  }
elif [ "$program" = 'audacious' ]; then
  findplay() {
    {  #  Make an Audacious empty playlist
    temporary_playlist=$( \mktemp  --suffix="--audacious-empty-playlist.asx" )
    \echo  "making temporary playlist:  $temporary_playlist"
    ( \cat << 'audacious-empty-playlist'
<?xml version="1.0" encoding="UTF-8"?>
<asx version="3.0">
<title>Now Playing</title>
</asx>
audacious-empty-playlist
) >> "$temporary_playlist"
      #less "$temporary_playlist"
    }

    {  #  Launch with the empty playlist
    \echo  ' * Launching Audacious..'
    \audacious  --enqueue-to-temp  "$temporary_playlist"  > /dev/null 2> /dev/null  &
    until
      \pidof  'audacious'
    do
      echo  ' * Waiting for audacious..'
      \sleep  0.1
    done
    #\sleep  1
    }

    {  #  Queue
    findqueue  "$*"
    }

    {  #  Play
    \audacious  --play
    }

    #:<<'  }'   #  Teardown
    {
      # shellcheck disable=1012
      \rm   --force  --verbose  "$temporary_playlist"
    }
  }
elif [ "$program" = 'vlc' ]; then
  findplay() {
    # There doesn't seem to be any functionality to clear the playlist when VLC is running.  Pathetic.
    # So instead, make an empty playlist:
    # VLC supports .xspf, .asx, .b4s and .m3u
    playlist_empty_vlc=$( \mktemp  --suffix="--empty-playlist--vlc.asx" )
    \echo  "making temporary playlist:  $playlist_empty_vlc"
    ( \cat << 'ASXv3'
<?xml version="1.0" encoding="UTF-8"?>
<asx version="3.0">
  <title>Now Playing</title>
</asx>
ASXv3
) > "$playlist_empty_vlc"

    \echo  ' * Launching vlc..'
    \setsid  /mnt/c/Program\ Files/VideoLAN/VLC/vlc.exe  --no-loop  "$playlist_empty_vlc"  > /dev/null 2> /dev/null  &
    #\echo  /mnt/c/Program\ Files/VideoLAN/VLC/vlc.exe  --no-loop  "$playlist_empty_vlc"
    until
      _=$( \pgrep  'vlc.exe' )
    do
      \echo  ' * Waiting for vlc..'
      \sleep  0.1
    done

    findqueue  "$@"

    # INT is ^C
    trap control_c INT
    control_c()
    {
      # shellcheck disable=1012
      \rm   --force  --verbose  "$playlist_empty_vlc"
    }
    \echo  ' * Waiting for exit..'
    until ! \
      _=$( \pgrep  'vlc.exe' )
    do
      \sleep  0.1
    done
    control_c
  }
else
  findplay() {
    \echo  'Error:  No media application has been found/set.'
    return  1
  }
fi
}   # /findplay





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



# Audacious has no functionality to just empty out its existing play list, but I can load an empty one.
#  .aupl
:<<'AUPL'
title=Now%20Playing
AUPL

#  .pls
:<<'PLS'
[playlist]
NumberOfEntries=0
PLS

#  .xspf
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

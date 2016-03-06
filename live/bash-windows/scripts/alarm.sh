#!/usr/bin/env  sh



\echo  'Alarm started.'

# TODO:  Is there a way to occasionaly display the remaining time?
\sleep $*


mshta.exe  "javascript:var sh=new ActiveXObject( 'WScript.Shell' ); sh.Popup( 'alarm', 10, '', 64 );close()"


if [[ -f '/c/Program Files/VideoLAN/VLC/vlc.exe' ]]; then
    /c/Program\ Files/VideoLAN/VLC/vlc.exe  --play-and-exit  "$WINDIR"/media/Notify.wav  vlc://quit   &> /dev/null
else
  echo 'No audio player was found.  Edit this script to add one.'
fi

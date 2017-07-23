#!/usr/bin/env  sh



if ! [[ -f "${PF}/VideoLAN/VLC/vlc.exe" ]]; then
  \echo  'No audio player was found.  Edit this script to add one.'
  \exit  1
fi

\echo  'Alarm started.'

# TODO:  Is there a way to occasionaly display the remaining time?
\sleep $*


mshta.exe  "javascript:var sh=new ActiveXObject( 'WScript.Shell' ); sh.Popup( 'alarm', 10, '', 64 );close()"


${PF}/VideoLAN/VLC/vlc.exe  --play-and-exit  "$WINDIR"/media/Notify.wav  vlc://quit   &> /dev/null

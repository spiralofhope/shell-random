#!/usr/bin/env  sh



:<<'Notes'
* I don't know how to detect an escape.  That would be nice.
  **  If I did the read character-by-character I could check for it.
* All kinds of possibilities might be doable here..
* I don't seem to be able to cut out the crap and just directly summon 'read' through sh or exec or nohup or such.
* I put a sleep 1 at the end because sometimes an application does nothing..
Notes



:<<'OpenBox rc.xml'   #  Creating a shortcut in Openbox's rc.xml:
<keybind key="W-r">
  <action name="Execute">
                                                                        <?ignore <!--
    Modify as necessary
                                                                        --> ?>
    <command>xterm -fn 9x15 -bg black -fg gray -cr darkgreen -sl 10000 -geometry 40x1+800+450 -title "Run" -exec readrun.sh</command>
  </action>
</keybind>
OpenBox rc.xml



\unset  READ
until [ ! "$READ" = "" ]; do
  \read  "READ"
done
\nohup  "$READ" > /dev/null 2> /dev/null &
\sleep  1

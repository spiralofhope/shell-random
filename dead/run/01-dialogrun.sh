#!/usr/bin/env  sh



:<<'OpenBox rc.xml'   #  Creating a shortcut in Openbox's rc.xml:
<keybind key="W-r">
  <action name="Execute">
                                                                        <?ignore <!--
    Modify as necessary
                                                                        --> ?>
    <command>xterm -fn 9x15 -bg black -fg gray -cr darkgreen -sl 10000 -geometry 40x1+800+450 -title "Run" -exec dialogrun.sh</command>
  </action>
</keybind>
OpenBox rc.xml



dialog --title "Dialog input box" \
   --inputbox "Text" 8 20\
   2>/tmp/dialog.$PPID
if [ $? = 1 ]; then
   clear
   exit 0
fi
ANS=`cat /tmp/dialog.$PPID`

exec nohup $ANS >> /dev/null&

rm -f /tmp/dialog.$PPID
exit 0

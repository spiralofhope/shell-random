\echo " - openbox: Configuring hotkeys (restoring to normality)"
dot=~/.config/openbox
\cp  --force  $dot/rc.xml-normal.xml  $dot/rc.xml
\openbox --reconfigure

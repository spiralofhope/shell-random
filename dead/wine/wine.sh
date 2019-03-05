\echo " - openbox: Configuring hotkeys (disabling most)"
dot=~/.config/openbox
\cp  --force  $dot/rc.xml-wine.xml  $dot/rc.xml
\openbox --reconfigure

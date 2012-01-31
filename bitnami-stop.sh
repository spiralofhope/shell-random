if ! [ $(whoami) = root ]; then
  \echo "You need to be root!"
else

\su user -c "/opt/bitnami/ctlscript.sh stop"
/opt/bitnami/ctlscript.sh stop

# Leftover stuff from failed starts.
\killall \
  ctl.sh \
  ctlscript.sh \
  &> /dev/null

# Kill log files before they bloat things up:
\cd ./bitnami-install/apache2/logs
\rm -f \
  ./access_log \
  ./error_log

fi

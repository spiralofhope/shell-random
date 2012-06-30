if ! [ $(whoami) = root ]; then
  \echo "You need to be root!"
else
  \su user -c "/opt/bitnami/ctlscript.sh stop"
  /opt/bitnami/ctlscript.sh stop \
    waitpid=$!

  # Leftover stuff from failed starts.
  \killall \
    ctl.sh \
    ctlscript.sh \
    &> /dev/null

  # Kill log files before they bloat things up:
  \rm --force \
    /opt/bitnami/apache2/logs/access_log \
    /opt/bitnami/apache2/logs/error_log

  # I did this nonsense just to get my prompt back when things end.
  # .. I don't like having to press enter.  =p
  \wait $waitpid
  \echo ''

  # If shit really hits the fan, nuke everything.
  \killall \
    httpd \
    mysqld.bin \
    &> /dev/null

  \wait $waitpid
  \echo ''
fi

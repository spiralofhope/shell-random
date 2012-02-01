if ! [ $(whoami) = root ]; then
  \echo "You need to be root!"
else

\adduser --no-create-home mysql &> /dev/null
if ! [ -d /opt/bitnami ]; then
  ln -s /home/bitnami-install /opt/bitnami &> /dev/null
fi

\chown -R user:users /home/bitnami-install
\chown -R user:users /home/bitnami-data

\echo ''
\echo ' * Starting MySQL.'
# MySQL must be started as a regular user.
\su user -c "/opt/bitnami/ctlscript.sh start mysql" &

\echo ''
\echo ' * Starting Apache.'
# Apache must be started as root.
/opt/bitnami/ctlscript.sh start apache & \
  waitpid=$!

# I did this nonsense just to get my prompt back when things end.
# .. I don't like having to press enter.  =p
\wait $waitpid
\echo ''

fi

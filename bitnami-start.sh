bitnami_dir=/z/mediawiki

if ! [ $(whoami) = root ]; then
  \echo "You need to be root!"
else

\adduser --no-create-home mysql &> /dev/null
if ! [ -d /opt/bitnami ]; then
  ln --force --symbolic $bitnami_dir/bitnami-install /opt/bitnami &> /dev/null
fi

\chown -R user:users $bitnami_dir/bitnami-install
\chown -R user:users $bitnami_dir/bitnami-data

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

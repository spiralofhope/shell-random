bitnami_dir=/z/mediawiki

if ! [ $(whoami) = root ]; then
  \echo "You need to be root!"
else
  \adduser --no-create-home mysql &> /dev/null

#
# Commented-out because I have an actual copy made at /opt
#
#  # Of course, there might be an actual file or directory at /opt/bitnami, but I ought to notice that..
#  if [ -s /opt/bitnami ]; then
#    \rm --force /opt/bitnami
#  fi
#  \ln --symbolic \
#    $bitnami_dir/bitnami \
#    /opt/bitnami
#
#  # This might be a bad idea!
#  \chown -R user:users $bitnami_dir/bitnami-install
#  \chown -R user:users $bitnami_dir/bitnami-data

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

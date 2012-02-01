# Tested 2010-11-21 on Lubuntu 10.10, updated recently.

if ! [ -d /opt/bitnami ]; then
  ln -s /home/bitnami-install /opt/bitnami
fi

# MySQL must be started as a regular user.
sudo -u user /opt/bitnami/ctlscript.sh start mysql &

# Apache must be started as root.
sudo /opt/bitnami/ctlscript.sh start apache &

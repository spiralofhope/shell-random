#!/usr/bin/env  sh



if ! [ $USER = 'root' ]; then
  \clear
  \echo  'root password:'
  /bin/su  --command  "$0"
else



  {  \echo  ' * Setup..'
    \cd  ~/l/bitnami/
    \mkdir  --verbose  --parents  /opt/bitnami/
    \mount  --verbose  -o bind   ./opt/bitnami  /opt/bitnami/
  }

  {  \echo  ' * MySQL..'
    \adduser  --disabled-login  --gecos ''  --no-create-home  mysql
    \chown  mysql  /opt/bitnami/mysql  --recursive
    \setsid  /opt/bitnami/ctlscript.sh  start  mysql &
    \chmod  -R  777  /opt/bitnami
    \chmod      770  /opt/bitnami/mysql/my.cnf

    # This used to work without creating the 'mysql' user:
    # MySQL must be started as a regular user.
    #\su  user  --command  '\setsid  /opt/bitnami/ctlscript.sh start mysql' &
  }

  {  \echo  ' * Apache..'
    \setsid  /opt/bitnami/ctlscript.sh  start  apache
  }

  {
    \echo  ''
    \echo  ''
    \echo  'The wiki is now accessible from either of:'
    \echo  '  http://localhost/wiki/'
    \echo  '  http://127.0.0.1/wiki/'
    \echo  ''
    \echo  'The logs are found at:'
    \echo  '  /opt/bitnami/apache2/logs/'
    \echo  '  /opt/bitnami/mysql/data/mysqld.log'
    \echo  ''
    \echo  ''
    \echo  'Press enter to stop.'
    \echo  ''
    \read  __
    /opt/bitnami/ctlscript.sh  stop
    \echo  '\n\n\n'
  }

  {  \echo  ' * Teardown..'
    # Kill log files before they bloat things up:
    \rm  --force  --verbose \
      /opt/bitnami/apache2/logs/access_log \
      /opt/bitnami/apache2/logs/error_log  \
      /opt/bitnami/mysql/data/mysqld.log
    \sleep 2
    # For some odd reason I have to do this twice sometimes..
    \umount  --verbose  /opt/bitnami
    \umount  --verbose  /opt/bitnami
    \rmdir   --verbose  /opt/bitnami
    #\userdel  mysql
  }


# As root
fi



:<<'old'
#!/usr/bin/env  sh


if ! [ $USER = 'root' ]; then
  /bin/su  -c  $0
else
  \cd  /path/
  \mkdir  --verbose  --parents  /opt/bitnami/
  \mount  --verbose  -o bind   ./opt/bitnami  /opt/bitnami/


  # NOTE - This works without creating the 'mysql' user

  \echo  ' * Starting MySQL..'
  # MySQL must be started as a regular user.
  \su  user  -c  "/opt/bitnami/ctlscript.sh start mysql" &

  \echo  ' * Starting Apache..'
  /opt/bitnami/ctlscript.sh  start  apache

  \echo  ' * The wiki is now accessible from either of:'
  \echo  '   http://localhost/wiki/'
  \echo  '   http://127.0.0.1/wiki/'


  # Logs
  # /opt/bitnami/apache2/logs/
fi
old



:<<'error notes'
/opt/bitnami/apache2/logs/error_log
  [Fri Jun 21 00:27:03 2019] [error] [client ::1] PHP Warning:  Unknown: Failed to write session data (files). Please verify that the current setting of session.save_path is correct (/opt/bitnami/php/tmp) in Unknown on line 0, referer: ht tp://localhost/mediawiki/index.php?title=PAGE_NAME&action=delete
I just hit it with a hammer:
  \chmod 777 /opt/bitnami/* -R

chmod u=rwx,o=rx,a=x bitnami -R

error notes


#!/usr/bin/env  sh
# Scrape comments from YouTube videos
# For the web-GUI of youtube-comment-scraper:
#   https://github.com/philbot9/youtube-comment-scraper/
# https://blog.spiralofhope.com/?p=45279
#
# See  `ytcs.sh`  for a commandline version.



if ! [ $USER = 'root' ]; then
  \clear
  \echo  'root password:'
  \sudo  "$0"
else

  {  #  startup
    if  [ ! -f '/var/run/docker.pid' ]; then
      \dockerd  2> /dev/null &
    fi
    \docker  run  --name="ytcomments-mongo" --restart="always"  -v  "$PWD":/data/db  -d mongo  2> /dev/null
    '/live/OS/Linux/bin/youtube-comment-scraper/youtube-comment-scraper/deploy'
    # I'm not going to bother exploring a smarter way to do this.
    \sleep 5
    \sudo  -u user  \x-www-browser  'localhost:49161'  2> /dev/null &
  }


  {
    \echo  ''
    \echo  ''
    \echo  'The wiki is now accessible from either of:'
    \echo  '  http://localhost:49161/'
    \echo  '  http://0.0.0.0:49161/'
    \echo  ''
    \echo  ''
    \echo  'Press enter to stop.'
    \echo  ''
    \read  __
  }


  {   #  teardown
    \docker  stop  $( \sudo  \docker  ps -aq )
    \docker  rm    $( \sudo  \docker  ps -aq )
    \systemctl  stop  containerd
    \systemctl  stop  dockerd
    # I have no idea how to actually fucking stop docker.
    \killall  dockerd  containerd
    \rm  /var/run/docker.pid
    \umount  /var/lib/docker/overlay2/*

    # I have permissions issues where things get re-owned by systemd-coredump.
    # This seems to be the right thing to do
    \echo  ' * Fixing symlinks (because this software is shit)..'
    \find  /home/user/  -exec \chmod  g+rw       {} \;
    # This will work, for a while.
    #\find  /home/user/  -exec \chown  user:user  {} \;

    \echo  ''
    \echo ' * Stopped.'
    \echo  ''

  }


# As root
fi

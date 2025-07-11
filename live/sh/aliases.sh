#!/usr/bin/env  sh

# FIXME - sudo may not always exist


alias  cls='\clear'
alias  cp='\cp  --interactive  --preserve=all'
alias  dash='\sh  -l'
#alias  df='_df_sorted 5'                                               # sorted by mountpoint
alias  df='_df_sorted 1'                                                # sorted by filesystem
alias  du='\du  --human-readable'
alias  eject='\eject  -i 0 ; \eject'                                    # Force-eject
alias  free='\free  --human  --si'
alias  grep='\grep  --color'                                            # Note that bash-windows does not support --color
alias  hibernate='drop-caches.sh  &&  \sudo  \systemctl  hibernate'
# See `sh/lib.sh` for the LESS variable.
#alias  less='LESS=  \less  --force  --RAW-CONTROL-CHARS  --quit-if-one-screen  $@'
alias  less='LESS=  \less  --chop-long-lines  --RAW-CONTROL-CHARS'
alias  ls='\ls  -1  --all  --classify  --color=always  --group-directories-first  --show-control-chars'
alias  md='\mkdir'
alias  more='LESS=  \less  --quit-at-eof  --quit-if-one-screen'
alias  mv='\mv  --interactive'
# Instead, use a config file like `nanorc`, see `which nanorc`
# alias  nano='\nano  --mouse'
alias  path='\echo  $PATH | \tr ":" "\012"'

#alias  pm-suspend='drop-caches.sh  &&  \sudo  /usr/sbin/pm-suspend'
#alias  suspend='drop-caches.sh  &&  \slock  &&  \systemctl suspend'
#alias  suspend='drop-caches.sh  &&  \sudo  \systemctl  suspend'
#alias  suspend='\systemctl suspend'
# I can't figure out how to integrate slock, so just use the default xscreensaver (reinstall it)
# xdg-screensaver
alias  suspend='\systemctl suspend'

alias  poweroff='\sudo  /sbin/poweroff'
alias  reboot='\sudo  /sbin/shutdown  -r  -t now  now  rebooting'
#alias  reboot="/bin/su  -c  '/sbin/shutdown  -r  -t now  now  rebooting'"
alias  rm='\rm  --interactive  --one-file-system'
alias  sh='\sh  -l'
alias  xclip='xclip -selection c'

# --QUIT-AT-EOF
# --no-init is mandatory for Windows Subsystem for Linux.
alias  myless='LESS=  \less  --no-init  --RAW-CONTROL-CHARS  --quit-if-one-screen'
#alias  dir='   dir-DOS-style.sh      |  \head  --lines='-1'  |  myless'

#alias  ddir='  dir-4DOS-style.sh  |  myless'
ddir() {
  if [ $# -eq 0 ];
  then  dir-4DOS-style.sh  .     |  myless
  else  dir-4DOS-style.sh  "$@"  |  myless
  fi
}
alias  dir='dir-4DOS-style.sh'


#ytdl(){
#  printf  '\033]0;...\007'
#  youtube-download.sh  "$@"
#  printf  '\n\n'
#}


# This won't work on cygwin, and I'm not even sure what it was for..
#alias  cd='\cd  --no-dereference'
#alias  ..='  \cd  --no-dereference  ..'
#alias  cd..='\cd  --no-dereference  ..'
alias  ..='  \cd  ..'
alias  cd..='\cd  ..'


alias  current='\cd   "$( \realpath  "$HOME/l/path/current/"  )"'
alias  previous='\cd  "$( \realpath  "$HOME/l/path/previous/" )"'


# 2016-03-26 - Lubuntu (version not recorded)
# 2016-03-28 - Slackware 14.1
#alias  su="\sudo  $( \basename  $( \readlink  /proc/$$/exe ) )"
#alias  sul='\sudo  \su  --login'


# TODO - What was I trying to achieve with this?
# TODO - Improve
#alias  killjobs='\kill  -9  $( \jobs -p )'


# TODO? - What does this do?
# alias  screen='TERM=screen screen'  # http://ubuntuforums.org/showthread.php?t=90910


update() {
  \sudo  \sh -c '
    /usr/bin/apt-get  --yes update        &&
    /usr/bin/apt-get  --yes upgrade       &&
    /usr/bin/apt-get  --yes dist-upgrade  &&
    /usr/bin/apt-get  --yes autoremove
  '
}
# 2025-01-11 - Ubuntu 24.04.1 LTS
# "Deferred due to phasing" is a system of holding back packages to test them on some installations before broadly deploying.
# This message is safe to ignore, but if you want to force-install, do:
#   sudo aptitude safe-upgrade
#
# Lubuntu also has:
# sudo /usr/bin/lubuntu-upgrader --cache-update --full-upgrade


# Help cache files, for a slow/occupied drive:
alias cnull='cat * > /dev/null&'

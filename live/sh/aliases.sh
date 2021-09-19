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
#alias  less='\less  --force  --RAW-CONTROL-CHARS  --quit-if-one-screen  $@'
alias  less='\less  --RAW-CONTROL-CHARS'
alias  ls='\ls  -1  --all  --classify  --color=always  --group-directories-first  --show-control-chars'
alias  md='\mkdir'
alias  more='\less  --quit-at-eof  --quit-if-one-screen'
alias  mv='\mv  --interactive'
alias  nano='\nano  --mouse'
alias  pm-suspend='drop-caches.sh  &&  \sudo  /usr/sbin/pm-suspend'
alias  poweroff='\sudo  /sbin/poweroff'
alias  reboot='\sudo  /sbin/shutdown  -r  -t now  now  rebooting'
#alias  reboot="/bin/su  -c  '/sbin/shutdown  -r  -t now  now  rebooting'"
alias  suspend='drop-caches.sh  &&  \sudo  \systemctl  suspend'
alias  rm='\rm  --interactive  --one-file-system'
alias  sh='\sh  -l'
alias  xclip='xclip -selection c'

# --QUIT-AT-EOF
# --no-init is mandatory for Windows Subsystem for Linux.
alias  myless='\less  --no-init  --RAW-CONTROL-CHARS  --quit-if-one-screen'
#alias  dir='   dir-DOS-style.sh      |  \head  --lines='-1'  |  myless'
alias  dir/a=' dir-DOS-style.sh /a   |  \head  --lines='-1'  |  myless'
alias  dir/d=' dir-DOS-style.sh /d   |  \head  --lines='-1'  |  myless'
alias  dir/ad='dir-DOS-style.sh /ad  |  \head  --lines='-1'  |  myless'

#alias  ddir='  dir-4DOS-style.sh  |  myless'
ddir() {
  if [ $# -eq 0 ];
  then  dir-4DOS-style.sh  .     |  myless
  else  dir-4DOS-style.sh  "$@"  |  myless
  fi
}
alias  dir='dir-4DOS-style.sh  .  |  myless'


ytdl(){
  printf  '\033]0;...\007'
  youtube-download.sh  "$@"
  printf  '\n\n'
}


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

# --
# --  Aliases for builtins
# --


# zshism:  nocorrect
alias  cp='nocorrect  \cp  --interactive'
alias  mv='nocorrect  \mv  --interactive'
alias  rm='nocorrect  \rm  --interactive'
alias  mkdir='nocorrect  \mkdir'
# bash-windows does not support --group-directories-first
alias  ls='\ls  --classify  --show-control-chars  --color=auto  --group-directories-first'




# TODO -- working from here, to migrate from 'zsh' to 'bash and zsh'



# I have no idea what -P means.  Screw you, past self.  Document more.
# FIXME - is there a long form for -P ?  There is no  man cd
alias  cd='\cd  -P'
# FIXME - none of this would work with autocomplete, so fuck it.
# todo - This needs to be tested.
: << DISABLED_cd
# Be able to cd into the directory of a file, because autocomplete gives a filename.
cd() {
## One would think something like this would work for multiple parameters, but it doesn't.  Well fuck it, the user (me) can \cd foo bar if they want to.
#  if [ x$2 == x ]; then
#    # do nothing
#    \echo -n ''
#  else
#    \cd  $@
#    return  $!
#  fi
#
  __="$1"
  if [ -f $1 ]; then
    # delete the crap off of the trailing slash
    __=$( \dirname "$1" )
 fi
  # check that what remains is sane
  [ -d $__ ]
  if [ $! -ne 0 ]; then
    \echo  ERROR:  This is not a directory:
    \echo  $__
    return  1
  fi
  # I have no idea what -P means.  Screw you, past self.  Document more.
  # FIXME - is there a long form for -P ?  There is no  man cd
  \cd  -P  "$__"
}
DISABLED_cd


#alias  rm='nocorrect  \rm  --interactive'
# Making rm smarter so it can remove directories too.  Fuck you, GNU.
# TODO? - Know when there are contents in directories to delete them?  It doesn't seem right to do this..
rm() {
  # TODO? - Shouldn't this loop through $@ and rmdir any directories?
  if [ -d $1 ] && [ ! -L $1 ]; then
    \rmdir  --verbose  "$1"
  else
    # I can't use \rm here, because it somehow still uses rm()
    nocorrect  /bin/rm  --interactive  "$@"
  fi
}



# --
# --  Aliases for software
# --


# This used to have  --exclude-type supermount
alias  df='\df  --human-readable'
# Go fuck yourself, drive.
alias  eject='\eject  -i 0 ; \eject'
# bash-windows does not support --color
alias  grep='\grep --color'

# TODO - What was I trying to achieve with this?
# TODO - Improve
#alias  killjobs='\kill  -9  $( \jobs -p )'

# TODO? - What does this do?
# alias  screen='TERM=screen screen'  # http://ubuntuforums.org/showthread.php?t=90910



# Slackware 12.2
#alias  slapt-get='slapt-get  --prompt'



# --
# --  Suffix aliases
# --


alias  -s txt=medit
alias  -s pdf=xpdf



# MIME is possible, but I can't figure it out.
# autoload -U zsh-mime-setup
# zsh-mime-setup



# --
# -- Linux console Applications
# --

# TODO - Works for Ubuntu.  Make this universal.
#alias  su="\sudo  $SHELL"
# Universal?
alias  su="\sudo  $( \basename  $( \readlink  /proc/$$/exe ) )"

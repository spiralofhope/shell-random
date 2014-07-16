: << IDEAS
  alias  screen='TERM=screen screen'  # http://ubuntuforums.org/showthread.php?t=90910
IDEAS



# TODO - Works for Ubuntu.  Make this universal.
alias  su="\sudo  $SHELL"

# FIXME - is there a long form for -P ?  There is no `man cd`
alias  cd='\cd  -P'
alias  ..='\cd  ..'
alias  cd..='\cd  ..'
alias  cf='\cd  /mnt/cf'
alias  sd='\cd  /mnt/sd'

alias  ls='\ls  --classify  --show-control-chars  --color=auto  --group-directories-first'

alias  cp='nocorrect  \cp  --interactive'

alias  mkdir='nocorrect  \mkdir'
alias  md='mkdir'

alias  mv='nocorrect  \mv  --interactive'

alias  rd='\rmdir'

#alias  rm='nocorrect  \rm  --interactive'
# Making rm smarter so it can remove directories too.  Fuck you, GNU.
rm() {
  if [ -d $1 ] && [ ! -L $1 ]; then
    \rmdir  --verbose  "$1"
  else
    # I can't use \rm here, because it somehow still uses rm()
    nocorrect  /bin/rm  --interactive  "$@"
  fi
}

alias  grep='\grep --color'

# This used to have  --exclude-type supermount
alias  df='\df  --human-readable'

alias  du='\du  --human-readable'

# Has  --raw-control-chars  earlier, but let's see if this is tidier.
alias  less='\less  --RAW-CONTROL-CHARS'
#alias less='\less  --force  --RAW-CONTROL-CHARS  --quit-if-one-screen  $@'
# --follow-name would allow the file to be edited and less will automatically display changes.
LESS=' --force  --ignore-case  --long-prompt  --no-init  --silent  --status-column  --tilde  --window=-2'
export LESS

# TODO - Improve
alias killjobs='\kill  -9  $( \jobs -p )'

alias cls='\clear'

# Go fuck yourself, drive.
alias eject='\eject  -i 0 ; \eject'



# Suffix aliases
alias  -s txt=medit
alias  -s pdf=xpdf



# MIME is possible, but I can't figure it out.
# autoload -U zsh-mime-setup
# zsh-mime-setup



# Ruby / shoes
# alias shoes="~/shoes/dist/shoes"

# Slackware 12.2
#alias  slapt-get='slapt-get  --prompt'


alias autotest="/l/Linux/bin/sh/autotest.sh"

alias smartgui="su -c \"smart --gui\""

alias ssfm='zsh -c "export LS_COLORS=\"no=00:fi=00:di=00;36:ln=00;35:pi=40;33:so=00;35:bd=40;33;01:cd=40;33;01:or=00;05;37;41:mi=00;05;37;41:ex=00;32:*.cmd=00;32:*.exe=00;32:*.com=00;32:*.btm=00;32:*.bat=00;32:*.sh=00;32:*.csh=00;32:*.tar=00;31:*.tgz=00;31:*.arj=00;31:*.taz=00;31:*.lzh=00;31:*.rar=00;31:*.zip=00;31:*.z=00;31:*.Z=00;31:*.gz=00;31:*.bz2=00;31:*.bz=00;31:*.tz=00;31:*.rpm=00;31:*.cpio=00;31:*.torrent=00;31:*.jpg=00;35:*~.jpg=00;33:*.gif=00;35:*.bmp=00;35:*.xbm=00;35:*.xpm=00;35:*.png=00;35:*.tif=00;35:*~.mp3=00;03:*~.ogg=00;03:*~.flv=00;03:*~.ape=00;03:*~.flv=00;03:*~.mpg=00;03:*~.wmv=00;03:*.part=00;03:\";ssfm"'
alias sfm=ssfm
alias shoes="~/shoes/dist/shoes"

# Ubuntu.  TODO: Make this unversal:
alias su="sudo $SHELL"
alias cd="\cd -P"
alias ..="cd .."
alias cd..="cd .."
alias cf="\cd /mnt/cf"
alias sd="\cd /mnt/sd"
alias d="ls"
alias l="ls"
alias la="ls -a"
alias ll="ls -l"
alias ls="\ls -F --show-control-chars --color=auto --classify"
alias lsd="ls -d *"
alias s="\cd .."
alias cp="\cp -i"
alias md="\mkdir"
alias mv="\mv -i"
alias rd="\rmdir"
# alias rm="\rm -i"
alias grep="\grep --color"
alias mc=". /usr/share/mc/bin/mc-wrapper.sh"
alias df="\df -h -x supermount"
alias du="\du -h"
alias less="less -r"
# To be improved:
alias killjobs="\kill -9 `jobs -p`"
# --follow-name would allow the file to be edited and less will automatically display changes.
LESS=" --force --ignore-case --long-prompt --no-init --silent --status-column --tilde --window=-2"
export LESS
#alias less="/usr/bin/less  -F -f -R $@"

# Suffix aliases
alias -s txt=medit
alias -s pdf=xpdf
alias -s sh=zsh

# MIME is possible, but I can't figure it out.
# autoload -U zsh-mime-setup
# zsh-mime-setup

# May need tweaking if I need to pass $@ parameters quoted..
# alias mount="/home/user/bin/mount.sh $@"

# Slackware 12.2
#alias slapt-get='slapt-get --prompt'

: << IDEAS

if ls --color  &>/dev/null; then
  ls_opt="--color" # gnu (linux)
else
  ls_opt="-G"      # mac
  #ls_opt="-F"
fi
alias ls="ls $ls_opt"

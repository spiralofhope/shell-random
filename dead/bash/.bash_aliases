# Called by ~/.bashrc


alias ls='ls  --color=auto'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

export  LS_COLORS="di=01;36"

alias du='\du  --human-readable'

alias sul='/bin/su  --login'
alias cp='\cp  --interactive'
alias mv='\mv  --interactive'
alias rm='\rm  --interactive'

_df_sorted () {
  _df () {
    \df --human-readable --exclude-type tmpfs --exclude-type devtmpfs
  }
  _df | \head --lines=1
  _df | \tail --lines=+2 | \sort --key=${1}
}
alias df='_df_sorted 1'


if    [ $( tty ) == /dev/tty1 ] || [ $( tty ) == /dev/tty2 ]; then
  \setfont  Uni2-VGA16.psf.gz
  \startx
  \logout
fi

df
\echo

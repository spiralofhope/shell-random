#!/usr/bin/env  bash
# Referenced by $HOME/.bashrc



#HISTCONTROL=ignoredups:ignorespace
HISTCONTROL=ignoreboth


# It really isn't quite right to leverage the existence of ~/.zshrc like this, but it works for my setup.
if [ "$( \whoami )" = 'root' ]; then
      bashdir="$( \realpath "$( \dirname "$( \realpath  /home/user/.zshrc )" )"/../../bash/ )"
else  bashdir="$( \realpath "$( \dirname "$( \realpath  ~/.zshrc          )" )"/../../bash/ )"
fi




PATH="$PATH":\
"$( \realpath  "$bashdir/scripts" )"\
` # `



# Have the `history` command use a better date format:
\export  HISTTIMEFORMAT="%Y-%m-%d_%T "


# Have tab cycle through choices
bind  'TAB:menu-complete'


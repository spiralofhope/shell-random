#!/usr/bin/env  bash



# It really isn't quite right to leverage the existence of ~/.zshrc like this, but it works for my setup.
if [ "$( \whoami )" = 'root' ]; then
      shdir="$( \realpath "$( \dirname "$( \realpath  /home/user/.zshrc )" )"/../../sh/ )"
else  shdir="$( \realpath "$( \dirname "$( \realpath  ~/.zshrc          )" )"/../../sh/ )"
fi
export  shdir



#:<<'}'  #  Paths
{
  PATH="${PATH:?}"\
:"$( \realpath  "${bashdir:?}/../bash/scripts" )"\
` # `
  \export  PATH
}

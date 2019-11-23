#!/usr/bin/env  bash



# It really isn't quite right to leverage the existence of ~/.zshrc like this, but it works for my setup.
if [ $( \whoami ) = 'root' ]; then
      export  shdir="$( \realpath $( \dirname $( \realpath  /home/user/.zshrc ) )/../../sh/ )"
else  export  shdir="$( \realpath $( \dirname $( \realpath  ~/.zshrc          ) )/../../sh/ )"
fi



#:<<'}'  #  Paths
{

  \export  PATH="$PATH"\
:"$( \realpath  "$bashdir/../bash/scripts" )"\
` # `

}

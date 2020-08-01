#!/usr/bin/env  sh
# Used by dash (sh)


:<<'}'   #  A common default ~/.profile
{
# ~/.profile: executed by Bourne-compatible login shells.

if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi

mesg n || true
}


#SHELL=/usr/bin/sh



# It really isn't quite right to leverage the existence of ~/.zshrc like this, but it works for my setup.
shdir="$( \realpath "$( \dirname "$( \realpath  /home/user/.zshrc )" )"/../../sh/ )"
export  shdir

# I don't actually use this variable anyway
#shell_random="$( \realpath "$shdir"/../../ )"



{  # 'source' additional scripting and settings.

  _pushd="$PWD"
  sourceallthat() {
    #\echo  "sourcing $1"
    \cd  "$1"  ||  return  $?
    if [ -f 'lib.sh' ]; then
      # shellcheck disable=1091
      .  './lib.sh'
    fi
    for i in *.sh; do
      if [ "$i" = 'lib.sh' ]; then
        continue
      fi
      #\echo  "running  ./$i"
      # shellcheck disable=1090
      .  "./$i"
    done
    \unset  i
  }

  sourceallthat  "$shdir/"
  sourceallthat  "$shdir/functions/"
  \cd  "$_pushd"  ||  return  $?

  \unset  -f  sourceallthat
  \unset      _pushd

}



#:<<'}'   #  A simple colored prompt
{
  # Make sure you have single-quotes ( ' ) around PS1 otherwise $PWD will never update within $PS1 again.

  :<<'  }'   #  A simple prompt:
  {
  if [ "$USER" = root ];
    then  PS1='${PWD} # '
    else  PS1='${PWD} $ '
  fi
  }


  # ANSI colors
  #
  # See sh/functions/colors.sh for more info.
  # Alternately it's possible to embed backticks and use ``echo -n <stuff>`  but that would keep executing echo which sounds slow.
  # I don't understand why these variables aren't available from the above..
  esc=''
  reset_color="${esc}[0m"
  boldon="${esc}[1m"
  red="${esc}[31m"
  blue="${esc}[34m"


  #:<<'  }'   #  A simple colored prompt:
  {
  if [ "$USER" = root ];
    then  PS1='${reset_color}${PWD}${boldon}${red} > ${reset_color}'
    else  PS1='${reset_color}${PWD}${boldon}${blue} > ${reset_color}'
  fi
  }


  #:<<'  }'   #  A complex prompt:
  # shellcheck disable=1117
  sh_prompt() {
    if [ ${#PWD} -gt 20 ]; then
      long_prompt='\n'
    fi
    \printf  '%b'  "${reset_color}${PWD}${long_prompt}${boldon}${1} > ${reset_color}"
  }

# Apparently necessary for zsh to be right here, for some reason..
precmd(){
  if [ "$( \whoami )" = root ];
    then  PS1="$( sh_prompt  "${red}"  )"
    else  PS1="$( sh_prompt  "${blue}" )"
  fi
}



}


if [ "$USER" = root ];
  then  PS1='${reset_color}${PWD}${boldon}${red} > ${reset_color}'
  else  PS1='${reset_color}${PWD}${boldon}${blue} > ${reset_color}'
fi

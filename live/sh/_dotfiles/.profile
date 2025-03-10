#!/usr/bin/env  sh
# Used by dash (sh)
# Manually run by zsh



:<<'}'   #  A common default ~/.profile :
{
# ~/.profile: executed by Bourne-compatible login shells.

if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi

mesg n || true
}



# It really isn't quite right to leverage the existence of ~/.zshrc like this, but it works for my setup.
shdir="$( \realpath "$( \dirname "$( \realpath  /home/user/.zshrc )" )"/../../sh/ )"
if ! [ -d "$shdir" ]; then
  \echo  "\$shdir is not a directory:  $shdir"
  return  1
fi
export  shdir



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
      # shellcheck disable=1090
      #\echo  "$i"
      .  "./$i"
    done
  }

  sourceallthat  "$shdir/"
  sourceallthat  "$shdir/functions/"
  \cd  "$_pushd"  ||  return  $?
  \unset      _pushd

  \unset  -f  sourceallthat
}



#:<<'}'  #  Colors
{
  # Note that these backslashes must not have a space preceeding them, nor must the following lines have spaces, as would normally be my scripting style.  Must end with a blank line.
  LS_COLORS=\
"$LS_COLORS"\
:"*.desktop=1;37"\
:"*.json=1;37"\
:"*.mhtml=1;37"\
:"*.html=1;37"\
:"*.url=1;37"\
:"*.webloc=1;37"\

}



#:<<'}'   #  A simple colored prompt
{
  :<<'  }'   #  A simple prompt:
  {
  # Single quotes ( ' ) are necessary to keep $PS1 updated.
  if [ "$USER" = root ];
    then  PS1='${PWD} # '
    else  PS1='${PWD} $ '
  fi
  }


  # ANSI colors
  #
  # This is from sh/functions/colours.sh , which has more info.
  initializeANSI
  #
  # Alternately it's possible to embed backticks and use ``echo -n <stuff>`  but that would keep executing echo which sounds slow.

  #:<<'  }'   #  A simple colored prompt:
  {
  # Single quotes ( ' ) are necessary to keep $PS1 updated.
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


# It's apparently necessary for this to be right here, but I don't know why:
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

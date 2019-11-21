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


# It really isn't quite right to leverage the existence of ~/.zshrc like this, but it works for my setup.
if [ $( \whoami ) = 'root' ]; then
      shdir="$( \realpath $( \dirname $( \realpath  /home/user/.zshrc ) )/../../sh/ )"
else  shdir="$( \realpath $( \dirname $( \realpath  ~/.zshrc          ) )/../../sh/ )"
fi

# I don't actually use this variable anyway
#shell_random="$( \realpath $( \dirname $( \realpath  /home/user/.zshrc ) )/../../../ )"



{  # 'source' additional scripting and settings.

  sourceallthat() {
    #\echo  "sourcing $1"
    \cd  "$1"
    if [ -f 'lib.sh' ]; then
      .  './lib.sh'
    fi
    for i in *.sh; do
      if [ "$i" = 'lib.sh' ]; then
        continue
      fi
      .  "./$i"
    done
    \unset  i
  }

  sourceallthat  "$shdir/"
  sourceallthat  "$shdir/functions/"

  \unset  -f  sourceallthat

}



# --follow-name would allow the file to be edited and less will automatically display changes.
LESS=' --force  --ignore-case  --long-prompt  --no-init  --silent  --status-column  --tilde  --window=-2'
export  LESS

SHELL=/usr/bin/sh
export SHELL



#:<<'}'   #  A simple colored prompt
{
  # Make sure you have single-quotes ( ' ) around PS1 otherwise $PWD will never update within $PS1 again.

  :<<'  }'   #  A simple prompt:
  {
  if [ $( \whoami ) = root ];
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
  red_bold="${boldon}${esc}${red}"
  blue_bold="${boldon}${esc}${blue}"


  :<<'  }'   #  A simple colored prompt:
  {
  if [ $( \whoami ) = root ];
    then  PS1='${reset_color}${PWD}${red_bold} > ${reset_color}'
    else  PS1='${reset_color}${PWD}${blue_bold} > ${reset_color}'
  fi
  }


  #:<<'  } }'   #  A complex prompt:
  { {
  # This is theoretically slower since it executes a command every time the prompt is re-drawn.
  sh_prompt() {
    if [ -z $1 ];
      then  color="${blue_bold}"  # user
      else  color="${red_bold}"   # root
    fi
    if [ $( \echo  -n  $( pwd ) |  \wc  --chars ) -gt 20 ];
      then  local  long_prompt="\n"
      else  local  long_prompt=''
    fi
    \echo  "${reset_color}${PWD}${color} > ${long_prompt}${reset_color}"
  }

  if [ $( \whoami ) = root ];
    then  PS1='$( sh_prompt  root )'
    else  PS1='$( sh_prompt       )'
  fi
  } }
}

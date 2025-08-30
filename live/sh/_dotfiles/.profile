#!/usr/bin/env  sh
# Used by dash (sh)
# Manually run by zsh


#STARTUP_DEBUG=true
export STARTUP_DEBUG
_debug() {
  [ $STARTUP_DEBUG ] && echo "$*"
}
_debug  'running ~/.profile'


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


# It's dumb to leverage the existence of ~/.zshrc like this, but it works for my setup.
shdir="$( \realpath  '/home/user/.zshrc' )"
shdir="${shdir%/*}"/../../sh/
# This shouldn't be needed.  Save startup speed by not launching yet another subshell:
#shdir="$( \realpath "$shdir" )"
_debug  ".profile has set \$shdir to $shdir"
if ! [ -d "$shdir" ]; then
  \echo  "\$shdir is not a directory:  $shdir"
  shdir=''
  export  shdir
  return  1
fi
export  shdir



{  # 'source' additional scripting and settings.
  _='.profile'
  _pushd="$PWD"
  _sourceallthat() {
    \cd  "$1"  ||  return  $?
    for i in *.sh; do
      _debug  "... $_ is sourcing $PWD/$i"
      # shellcheck disable=1090
      .  ./"$i"
      #if $STARTUP_DEBUG; then
        #.  ./"$i"
      #else
        #.  ./"$i"   > /dev/null  2> /dev/null
      #fi
    done
  }

  .  "$shdir/lib.sh"
  _sourceallthat  "$shdir/"
  _sourceallthat  "$shdir/functions/"
  \cd  "$_pushd"  ||  return  $?
  \unset      _pushd
  \unset  -f  _sourceallthat
}



#:<<'}'  #  Colors
{
  # Note that these backslashes must neither have a space preceeding them, nor must the following lines have spaces, as would normally be my scripting style.  Must end with a blank line.
  LS_COLORS=\
"$LS_COLORS"\
:"*.desktop=1;37"\
:"*.json=1;37"\
:"*.mhtml=1;37"\
:"*.html=1;37"\
:"*.url=1;37"\
:"*.webloc=1;37"\

}



#:<<'}'   #  Prompt
{
  #
  # Using ANSI colors from  `sh/functions/colours.sh`
  #   Loaded during  `sourceallthat()`  above.
  #   \echo  -n  "${yellow}this is a color test${reset_color}"

  #if [ "$( \whoami )" = root ];
  # more portable than whoami:
  #if [ "$( \id -un )" = root ];
  #if [ "$UID" = 0 ];
  if [ "$USER" = root ];
    then user_prompt_color="$red"
    else user_prompt_color="$blue"
  fi


  #:<<'  }  # long lines'
  {
    if [ $( \ps -p $$ -o comm= ) = 'sh' ]; then
      prompt_command() {
        # dash uses PS1 exclusively, and single-quotes for PS1=''
        if [ ${#PWD} -gt 20 ];
        then \printf  '%b'  "${reset_color}${PWD}${boldon}${user_prompt_color}\n> ${reset_color}"
        else \printf  '%s'  "${reset_color}${PWD}${boldon}${user_prompt_color} > ${reset_color}"
        fi
      }
      PS1='$( prompt_command )'
    else
      # zsh uses precmd instead, and double-quotes for PS1=""
      precmd() {
        if [ ${#PWD} -gt 20 ];
        then PS1="$( \printf  '%s'  "${reset_color}${PWD}${boldon}${user_prompt_color}${carriage_return}> ${reset_color}" )"
        else PS1="$( \printf  '%s'  "${reset_color}${PWD}${boldon}${user_prompt_color} > ${reset_color}" )"
        fi
      }
    fi
  }  # long lines

# /Prompt
}

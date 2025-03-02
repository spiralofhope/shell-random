#!/usr/bin/env  sh
# shellcheck disable=1001



# By using screen, all instances of 'su' will be "under one roof", to avoid multiple instances of a root window.  Because that's terribly insecure.


# 2016-03-26, on Lubuntu (version not recorded)
# 2016-03-28, on Slackware 14.1
#alias  su="\sudo  $( \basename  $( \readlink  /proc/$$/exe ) )"
#alias  sul='\sudo  \su  --login'


#:<<'}'   #  Let root become the user.
{
  suu() {
    # TODO - tweak this to make a sort of `sudouser`
    if [ -z "$1" ]; then
      \sudo  -u user  "$SHELL"
    else
      \sudo  "$@"
    fi
  }
}


#:<<'}'  #  If `sudo` does or does not exist.
{
  if
    _=$( \which  \sudo )
  then   # sudo exists
    #su() {
      #\sudo  "$1"  \screen  -q  -X setenv currentdir "$( \pwd )"
      #\sudo  "$1"  \screen  -q  -X eval 'chdir $currentdir' screen
      ## This logs out of any existing instance of root.
      #\sudo  "$1"  \screen -A  -D -q  -RR
    #}
    # Under 32bit Debian, somehow su() does not work.
    sul() {
      # This is going to be running all the startup scripts and configuration multiple times.  That's probably stupid, and maybe there needs to be a check in those configuration files so they don't let themselves get reloaded.
      \sudo  --login  "$1"  \screen  -q  -X setenv currentdir "$( \pwd )"
      \sudo  --login  "$1"  \screen  -q  -X eval 'chdir $currentdir' screen
      # This logs out of any existing instance of root:
      \sudo  --login  "$1"  \screen  -A  -D  -q  -RR
    }
  else   # sudo does not exist
    su() {
      # shellcheck disable=2117
      /bin/su
    }
    sul() {
      # shellcheck disable=2117
      /bin/su  '--login'
    }
    sudo() {
      # 2020-03-25 - I have no idea what that parameter is..
      # shellcheck disable=2117
      /bin/su  --close-from="$*"
    }
  fi
}

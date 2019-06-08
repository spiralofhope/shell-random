#!/usr/bin/env  zsh



# By using screen, all instances of 'su' will be "under one roof", to avoid multiple instances of a root window.  Because that's terribly insecure.


# 2016-03-26, on Lubuntu (version not recorded)
# 2016-03-28, on Slackware 14.1
#alias  su="\sudo  $( \basename  $( \readlink  /proc/$$/exe ) )"
#alias  sul='\sudo  \su  --login'


suu() {   # Let root become the user.
  # TODO - tweak this to make a sort of `sudouser`
  if [ -z $1 ]; then
    \sudo  -u user  $SHELL
  else
    \sudo  $*
  fi
}


suul() {
  suu  '--login  -u user'
}



{   # If `sudo` does or does not exist.
\which  sudo > /dev/null
if [ $? -eq 0 ]; then   # sudo exists

  su() {
    \sudo  $1  \screen  -q  -X setenv currentdir `\pwd`
    \sudo  $1  \screen  -q  -X eval 'chdir $currentdir' screen
    # This logs out of any existing instance of root.
    \sudo  $1  \screen -A  -D -q  -RR
  }


  sul() {
    \sudo  --login  $1  \screen  -q  -X setenv currentdir `\pwd`
    \sudo  --login  $1  \screen  -q  -X eval 'chdir $currentdir' screen
    # This logs out of any existing instance of root.
    \sudo  --login  $1  \screen -A  -D -q  -RR
  }


  else   # sudo does not exist


  su() {
    /bin/su
  }


  sul() {
    /bin/su  '--login'
  }


  sudo() {
    /bin/su  --close-from=$*
  }

fi  # If `sudo` does or does not exist.
}

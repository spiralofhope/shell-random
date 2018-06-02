#!/usr/bin/env  zsh



\which  sudo > /dev/null
if [ $? -eq 0 ]; then
  _sudo_exists='true'
else
  _sudo_exists='false'
fi



# 2016-03-26, on Lubuntu (version not recorded)
# 2016-03-28, on Slackware 14.1
#alias  su="\sudo  $( \basename  $( \readlink  /proc/$$/exe ) )"
#alias  sul='\sudo  \su  --login'

# All instances of 'su' will be "under one roof", to avoid multiple instances of a root window.  Because that's terribly insecure.
# 2016-03-29, on Slackware 14.1
su() {
  if [ $_sudo_exists = 'true' ]; then
    \sudo  $1  \screen  -X setenv currentdir `\pwd`
    \sudo  $1  \screen  -X eval 'chdir $currentdir' screen
    # This logs out of any existing instance of root.
    \sudo  $1  \screen -A  -D -RR
  else
    # 2016-10-29, on Porteus-LXQt-v3.1-i486
    /bin/su
  fi
}
sul() {
  /bin/su  '--login'
}
# Let root become the user.
# Basically the reverse of the above.
# TODO - tweak this to make a sort of `sudouser`
# 2016-04-01, on Slackware 14.1
suu() {
  if [ -z $1 ]; then
    \sudo  -u user  $SHELL
  else
    \sudo  $*
  fi
}
suul() {
  suu  '--login  -u user'
}



# 2016-10-29, on Porteus-LXQt-v3.1-i486
if [ $_sudo_exists = 'false' ]; then
  sudo() {
    /bin/su  -c $*
  }
fi

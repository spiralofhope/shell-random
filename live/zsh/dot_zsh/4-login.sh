# /etc/zlogin and ~/.zlogin
# Read after zshrc, if the shell is a login shell.
# See also /etc/default/console-setup


########  This file cannot be written-to while the system is using it!
# NOTE #  That means you cannot be in X.
########


# No need if booting is otherwise set up correctly:
\setfont  Uni2-VGA16.psf.gz


# This mess lets me use the console login screen as a GUI login manager.

# if [ -z "$DISPLAY" ] && [ $( \tty ) == /dev/tty1 ]; then

if    [ "$TTY" = '/dev/tty1' ] ||\
      [ "$TTY" = '/dev/tty2' ]; then




#:<<'}'  #  Detect network connection
         #  FIXME? - This doesn't necessarily mean "internet connection"
{
  # 'lo' is localhost, which is always there so it doesn't count as an outside connection.
  for interface in $( \ls /sys/class/net/  |  \grep  --invert-match  lo ); do
    \echo "Processing $interface"
    _result=$( \cat /sys/class/net/"$interface"/carrier )
    #\echo  "$_result"
    __="/tmp/$( \whoami ).autostart-networking-applications"
    if [ "$_result" = '1' ]; then
      \dialog  --yesno  "Network connection detected.\n\nAutostart related applications?"  0  0
      if [ $? -eq 0 ];
      then  \touch        "$__"
      else  \rm  --force  "$__"
      fi
      \unset  __
    else
      \echo  ' * Network connection not detected.'
      \rm  --force  "$__"
    fi
  done
}























# This is a nice idea, but I think I need to chain zsh in the middle of things, unless I want to fuck around with the default shell..  perhaps `dtach` would work, but I don't know..
#  echo $$ !> /tmp/zsh-launching-startx.ppid
#  dtach -n /tmp/dtach.socket  \startx &

  # Find the TTY number
  #  e.g.  /dev/tty2  =>  2
  string="$TTY"
  pattern='/dev/tty'
  local  tty_to_use=${string##${pattern}}
  tty_to_use=${string##*${pattern}}

#less /usr/bin/startx



# Earlier successes:
  # Be really specific, so that we can setsid to exit entirely out of zsh or sh:
# As of Devuan 2.0.0 this works as root but not as a user:
#  \setsid  xinit /etc/X11/xinit/xinitrc -- /usr/bin/X :$( \expr "$tty_to_use" - 1 ) vt"$tty_to_use" -auth $( \tempfile --prefix='serverauth.' )

  # Start X on that specific TTY
  #\setsid  \startx  --  vt"$tty_to_use"

# xinit "$client" $clientargs -- "$server" $display $serverargs




# 2018-11-10 - Devuan 2.0.0
#
# This will open Openbox
#setsid  \startx
#\logout


# 2018-12-28 - Devuan 2.0.0 before new computer
#
# This will open Openbox
#nohup  setsid  \startx > /dev/null
#\logout


# 2018-12-29 - Devuan 2.0.0 after new computer
#
# Launches X but doesn't switch to it:
#startx
# Launches X but doesn't switch to it:
#setsid  \startx
# Launches X but doesn't switch to it:
#nohup  setsid  \startx > /dev/null
# Launches MATE:
#\setsid  
\xinit  /etc/X11/xinit/xinitrc -- /usr/bin/X :$( \expr "$tty_to_use" - 1 ) vt"$tty_to_use"  -auth $( \tempfile  --prefix='serverauth.' )
logout


fi  # ttys 1,2

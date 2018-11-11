#!/usr/bin/env  zsh
# zsh.  Because fuck all of bash's heredoc and array bullshit.

# --
# -- terminal.sh
# -- Run through various terminals to find one which is installed.
# --



# --
# -- Is a terminal not tabbed?
# --
#
# tabbed
#
#   http://tools.suckless.org/tabbed/
#   Invocation notes are at the bottom of this script.
#   TODO - customize tabbed:
#     - Set a maximum tab width.
#     - control-pageup/pagedown to change tabs
#     - control-shift-pageup/pagedown to move a tab
#     - control-t to spawn a new tab
#     - alt-n to change to a specific tab
#
# (window manager)
#
#   Some window managers allow any arbitrary application to be tabbed.
#   TODO - give a rough list



# --
# -- Is a terminal not tabbed?
# -- Does a terminal not support scrollback?
#
#    Consider a terminal multiplexer.
#    TODO - I have notes on other terminal multiplexers.
#
# tmux
#
#   http://tmux.sourceforge.net/
#   TODO - customize the scrollback
#     uses C-b [
#
# screen
#
#   https://www.gnu.org/software/screen/
#   TODO - customize the scrollback
#     uses C-a ESC  --  This is the copy feature.  Sigh, GNU.
#   One optimal invocation might be:  \screen  -a  -D  -R  -q  -T term  -h 1000  -x   .. but I can't get this to work for me.
#     \xterm  -fn vga  -bg black  -fg gray  -cr darkgreen  -sl 10000  -geometry 80x24+0+0  -e \screen -q



# Sometimes the user knows what they're doing, and there's really no need for this script at all.
if [[ "x$1" == 'xFORCE' ]]; then
  # Nuke $1
  shift
  \echo  "Force-running \"$@\""
  \setsid  "$@" &
  \exit  0
fi



trim_whitespace() {
  \echo  $1 | \xargs
}



terminal_setup() {
  # Check for my favourite font, with a safe fallback.
  font='-*-fixed-medium-*-*-*-14-*-*-*-*-*-*-*'
  # Unicode vga font, installed via 'unicode-vga/u_vga16.pcf.sh'
  # Note - If this looks like shit when bold, make sure ~/.Xresources is there.
  font='-bolkhov-vga-medium-r-normal--16-160-75-75-c-80-iso10646-1'
  # TODO - `xlsfonts` may not always exist.
  \xlsfonts  |  \grep  --line-regexp  --quiet  --  $font
  if  [[ $? -eq 1 ]]; then
    # This is the vga font taken from DOSEmu.  Non-unicode.
    font='vga'
    \xlsfonts  |  \grep  --line-regexp  --quiet  --  $font
    if  [[ $? -eq 1 ]]; then
      # This should be available on a default install.
      font='-*-fixed-medium-*-*-*-14-*-*-*-*-*-*-*'
    fi
    # Most terminals have a default fallback font in place.  Most.  I'm looking at you, urxvt.
  fi

  # Note that I am unable to do something like  \terminal_name  to guarantee I'm not bumping into an alias or the like.
  #   So instead, I am using absolute paths.
  #   TODO - Figure out how to use  \terminal_name
  terminals_without_lines=(
    /usr/bin/urxvt
    /usr/bin/rxvt-unicode
    /usr/bin/rxvt
    /usr/bin/mrxvt
    /usr/bin/mate-terminal
    /usr/bin/lxterminal
    /usr/bin/sakura
    /usr/bin/Terminal
    /usr/bin/gnome-terminal
    /usr/bin/Terminal
    /usr/bin/terminal
    /usr/bin/lilyterm
    /usr/bin/roxterm
    /usr/bin/terminator
    /usr/bin/st
    Eterm
    /usr/bin/evilvte
    /usr/bin/aterm
    /usr/bin/xterm
  )

  terminals_with_lines=(
    /usr/bin/urxvt
    /usr/bin/rxvt-unicode
    /usr/bin/mate-terminal
    /usr/bin/lxterminal
    /usr/bin/sakura
    /usr/bin/Terminal
    /usr/bin/evilvte
    /usr/bin/st
    /usr/bin/xterm
  )
}



determine_which_terminal_to_run() {
  determine_terminal_existance() {
    for i in "$@"; do
      i=$( \echo  $( trim_whitespace  $i ) )
      \which  $i > /dev/null
      if [ $? -eq 0 ]; then
        \echo  $i
        break
      fi
    done
  }

  if [[ "x$1" == 'xwith_lines' ]]; then
    # Nuke $1
    shift
    determine_terminal_existance  $terminals_with_lines
  else
    determine_terminal_existance  $terminals_without_lines
  fi
}



launch_terminal() {
  if [[ "x$1" == 'x' ]]; then
    \echo  'ERROR:  No valid terminal was found.  Edit this script to add one.'
    exit  1
  else
    \echo  "Running $1"
  fi

  # The below two lines let me use $i to refer to $1 and "$@" to refer to $2 $3 $4 etc.
  #   TODO - is there a $2* or some such?
  i="$1"
  shift
  case "$i" in

    /usr/bin/aterm)
      # aterm
      # http://www.afterstep.org/aterm.php
      # Not tabbed
      # TODO - Does this thing actually have *no* dependencies?
      # In maintenance mode since 2007-08-01.
      # No unicode support.  They recommend using rxvt-unicode
      # Slow scrolling.
      \setsid  $i \
        ` # Output to the window should not have it scroll to the bottom.` \
        -si \
        ` # No visual bell. ` \
        +vb \
        ` # No scrollbar. ` \
        +sb \
        ` # The default font can do fancy designs. ` \
        ` # -font default ` \
        ` # My font addition ` \
        ` # This is not necessary if  aterm*font:  has been set in ~/.Xdefaults but it is nice to do here because of the default fallback. ` \
        -fn $font \
        -bg black \
        -fg gray \
        -cr darkgreen \
        -sl 10000 \
        -geometry 80x24+0+0 \
        "$@" &
    ;;

    Eterm)
      # Eterm
      # http://www.eterm.org/
      # Tabbed
      # TODO - font
      # TODO - geometry
      # Has dependencies.. I don't want to use it.
      \setsid  $i  "$@" &
    ;;

    /usr/bin/evilvte)
      # evilvte
      # TODO - website
      # Tabbed
      # TODO - font
      # TODO - geometry
      # evilvte CLAIMS to have a geometry feature, but it doesn't ACTUALLY have one!
      #   Maybe I can force something through the window manager, but I'd want it to only be temporarily forced.  evilvte can give itself a custom WM_CLASS class and WM_CLASS name.  Maybe I can leverage that.
      \setsid  $i  "$@" &
    ;;

    /usr/bin/gnome-terminal)
      # TODO - name
      # TODO - Website
      # Bloated, but at least it can use the default system fixed width font so it looks right.
      # Tabbed
      # TODO - font
      \setsid  $i \
      --geometry 80x24+0+0 \
      "$@" &
    ;;

    /usr/bin/lilyterm)
      # TODO - name
      # http://lilyterm.luna.com.tw/
      # Tabbed
      # TODO - font
      # TODO - geometry
      \setsid  $i  "$@" &
    ;;

    /usr/bin/lxterminal)
      # LXTerminal
      # http://wiki.lxde.org/en/LXTerminal
      # http://sourceforge.net/projects/lxde/files/LXTerminal%20%28terminal%20emulator%29/
      # Tabbed
      #   New tabs are opened in the same directory as the current tab.
      # I cannot set a font at the command line.
      \setsid  $i \
        --geometry=80x24 \
        "$@" &
    ;;

    /usr/bin/mrxvt)
      # TODO - name
      # http://materm.sourceforge.net/wiki/
      # (Formerly materm)
      # TODO - my options from the Zaurus
      # Tabbed
      # TODO - font
      # TODO - geometry
      \setsid  $i  "$@" &
    ;;

    /usr/bin/roxterm)
      # TODO - name
      # http://roxterm.sourceforge.net/
      # Tabbed
      # TODO - font selection
      # TODO - geometry
      # This term doesn't feel right
      \setsid  $i  "$@" &
    ;;

    /usr/bin/xfce4-terminal)
      # TODO - name, comes with the xfce desktop
      # TODO - website
      # Tabbed
      \setsid  $i  "$@" &
    ;;

    /usr/bin/rxvt)
      # Under Slackware 14.1, it sets "xterm" as its terminal, but it doesn't act properly and zsh/bindkeys will be unhappy.

      # rxvt
      # http://www.rxvt.org/
      # rxvt is an alias to rxvt-unicode when rxvt-unicode is installed.
      # I make changes to ~/.Xdefaults for things like fonts.
      \setsid  $i \
        ` # Output to the window should not have it scroll to the bottom.` \
      -si \
        ` # No visual bell. ` \
      +vb \
        ` # No scrollbar. ` \
      +sb \
        ` # Jump scrolling.  Normally, text is scrolled one line at a time; this option allows xterm to move multiple lines at a time so that it does not fall as far behind. Its use is strongly recommended since it makes xterm much faster when scanning through large amounts of text. ` \
      -j \
      -fn $font \
      -bg black \
      -fg gray \
      -cr darkgreen \
      -sl 10000 \
      -geometry 80x24+0+0 \
      "$@" &
    ;;

    /usr/bin/rxvt-unicode|/usr/bin/urxvt)
      # urxvt / rxvt-unicode
      # http://software.schmorp.de/pkg/rxvt-unicode
      # This dumbass terminal does not have a proper fallback if I use an invalid font.
      # See ~/.Xresources

      \which xlsfonts > /dev/null
      if [ $? -eq 0 ]; then
        \echo "I can probably use a font, trying.."
        # Note - See `man 7 urxvt` for more on fonts, but not that much more.. so good luck.
        # 2016-11-24 - on Devuan  =  Linux devuan 3.16.0-4-686-pae #1 SMP Debian 3.16.36-1+deb8u2 (2016-10-19) i686 

        # 2016-11-24 - on Devuan
        #font='-*-fixed-medium-*-*-*-14-*-*-*-*-*-*-*'
        # 2016-11-24 - on Devuan after 'unicode-vga' is installed.
        # Note - If this looks like shit when bold, make sure ~/.Xresources is there.
        #font='-bolkhov-vga-medium-r-normal--16-160-75-75-c-80-iso10646-1'
        # 2016-11-24 - on Slackware 14.1
        #font='xft:Bitstream Vera Sans Mono:pixelsize=13:autoalias=false'
        # 2016-11-24 - on Devuan
        #font='xft:Bitstream Vera Sans Mono:pixelsize=12:autohint=true:autoalias=false'
        # 2016-11-24 - on Devuan
        #font='xft:Bitstream Vera Sans Mono'
        \setsid  \urxvtc  -fn $font  -bg black  -fg grey  "$@"
        if [ $? -eq 2 ]; then
          \echo "urxvtd is not running, running it"
          \setsid  \urxvtd  --fork  --opendisplay  --quiet
          \setsid  \urxvtc  -fn $font  -bg black  -fg grey  "$@"
        fi
        
      else
        \echo "I doubt I can use a font, skipping.."
        \setsid  \urxvtc  -bg black  -fg grey  "$@"
        if [ $? -eq 2 ]; then
          \echo "urxvtd is not running, running it"
          \setsid  \urxvtd  --fork  --opendisplay  --quiet
          \setsid  \urxvtc  -bg black  -fg grey  "$@"
        fi
      fi
      if [ $? -ne 0 ]; then
        # Just fucking work..
        \setsid  \urxvtc  -fn 'xft:'
        if [ $? -eq 2 ]; then
          \echo "urxvtd is not running, running it"
          \setsid  \urxvtd  --fork  --opendisplay  --quiet
          \setsid  \urxvtc  -fn 'xft:'
        fi
      fi
    ;;

    /usr/bin/sakura)
      # Sakura
      # http://pleyades.net/david/sakura.php
      # Tabbed
      # When using bash as the default shell, the prompt doesn't immediately appear.
      #   zsh works fine.
      # TODO - font
      \setsid  $i \
      --geometry 80x24+1+1 \
      "$@" &
    ;;

    /usr/bin/st)
      # Simple Terminal
      # http://st.suckless.org/
      # Not tabbed.
      # TODO - font
      # TODO - geometry
      # TODO - The title does not change when the current working directory is changed.
      #        I have been unable to fix this.
      \setsid  $i  "$@" &
    ;;

    /usr/bin/Terminal)
      # TODO - name
      # TODO - Website
      # Tabbed
      # TODO - font
      \setsid  $i \
      --geometry 80x24+0+0 \
      "$@" &
    ;;

    /usr/bin/terminal)
      # TODO - name
      # TODO - Website
      # Tabbed
      # TODO - font
      \setsid  $i \
      --geometry 80x24+0+0 \
      "$@" &
    ;;

    /usr/bin/terminator)
      # Terminator
      # http://software.jessies.org/terminator/
      # Tabbed
      # Holy shit, their geometry is pixel based, not character based like everyone else in the universe.
      #\terminator --geometry 80x24+0+0 "$@"
      \setsid  $i \
        --geometry +0+0 \
        "$@" &
    ;;

    /usr/bin/xterm)
      # TODO - name
      # http://invisible-island.net/xterm/
      # Tabbed
      \setsid  $i \
        ` # Output to the window should not have it scroll to the bottom.` \
      -si \
        ` # No visual bell. ` \
      +vb \
        ` # No scrollbar. ` \
      +sb \
        ` # Jump scrolling.  Normally, text is scrolled one line at a time; this option allows xterm to move multiple lines at a time so that it does not fall as far behind. Its use is strongly recommended since it makes xterm much faster when scanning through large amounts of text. ` \
      -j \
        ` # Indicates that xterm may scroll asynchronously, meaning that the screen does not have to be kept completely up to date while scrolling. This allows xterm to run faster when network latencies are very high and is typically useful when running across a very large internet or many gateways. ` \
      -s \
        ` # My font addition ` \
      -fn $font \
        ` # xterm should assume that the normal and bold fonts have VT100 line-drawing characters.  It sets the forceBoxChars resource to "true". ` \
      +fbx \
      -bg black \
      -fg gray \
      -cr darkgreen \
      -sl 10000 \
      -geometry 80x24+0+0 \
      "$@" &
    ;;

    *)
      \echo  ''
    ;;
  esac
}



terminal_setup
terminal_to_run="$( \echo  $( determine_which_terminal_to_run ) )"
launch_terminal  "$terminal_to_run"



exit $?
# --
# -- TODO - tabbed st
# --
# This code worked when it was created, but that was for a different edition of terminal.sh

# st doesn't support scrollback, so I need a multiplexer for that.
run_tabbed_st_if_they_exist() {
  \which \tabbed > /dev/null   ;   local  tabbed=$?   ;   if  [ $tabbed -ne 0 ]; then return 1; fi
  \which \st     > /dev/null   ;   local  st=$?       ;   if  [ $st     -ne 0 ]; then return 1; fi

  \which \screen > /dev/null   ;   local  screen=$?
  \which \tmux   > /dev/null   ;   local  tmux=$?
  if [ $screen -ne 0 ] && [ $tmux -ne 0 ]; then return 1; fi

  # TODO - Figure out which one I want by default.
  if [[ $screen -eq 0 ]]; then
    local terminal_multiplexer=\screen
  elif [[ $tmux -eq 0 ]]; then
    local terminal_multiplexer=\tmux
  fi

  # These were erratic:
  #   local  windowid=tabbed-$$
  #   local  windowid=$( \mktemp  --dry-run )
  #   local  windowid=tabbed-$$-$( \mktemp  --dry-run )
  # This is imperfect, but it'll do.  Depends on GNU coreutils.
  local  windowid=$( \date  +%s )  # The number of seconds since "UNIX epoch" (1970-01-01).
  \tabbed \
    -c               ` # Close tabbed when the last tab is closed. ` \
    -r 2             ` # will replace the narg th argument in command with the window id, rather than appending it to the end. ` \
                     ` # I have no clue what this does, but it's key to making everything work.  ` \
    \st \
      -w $windowid   ` # Attach st to a specific window. ` \
                     ` # I've made that window unique, so I can spawn multiple instances of tabbed+st, e.g. for multiple desktops. ` \
      -e $terminal_multiplexer \
  &
  exit  0
}

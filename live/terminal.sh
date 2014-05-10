#!/bin/zsh
# zsh.  Because fuck all of bash's heredoc and array bullshit.


# OH FUCK ME!
# evilvte SAYS it has a geometry feature, but it doesn't ACTUALLY have one.  Fuck right off!
# Maybe I can force something through the window manager, but I'd want it to only be temporarily forced.  evilvte can give itself a custom WM_CLASS class and WM_CLASS name.  Maybe I can leverage that.


# --
# -- terminal.sh
# -- Run through various terminals to find one which is installed.
# --



# Is a terminal not tabbed?  Consider a terminal multiplexer like  `screen`  or  `tmux`
#   `screen`  screws up the scrollback.
#   One optimal usage might be:  \screen  -a  -D  -R  -q  -T term  -h 1000  -x   .. but I can't get this to work for me.
#   \xterm  -fn vga  -bg black  -fg gray  -cr darkgreen  -sl 10000  -geometry 80x24+0+0  -e \screen -q



# Sometimes the user knows what they're doing, and there's really no need for this script at all.
if [[ "x$1" == "xFORCE" ]]; then
  # Nuke $1
  shift
  \echo  "Running $@"
  \eval  $@
  \exit  0
fi



terminal_setup() {
  # This fixes a GNOME hotkey issue which was starting the terminal in /
  #   I don't know if this breaks any other usage!
  #\cd  ~

  # 2014-05-10 - This bit here very old.  I'm not even installing that vga font any more.  It's been left here for reference.
  # This was for Unity Linux, possibly for Ubuntu/Lubuntu.  Does not apply to Gentoo/Sabayon.
  #
  # Check for my favourite font, with a safe fallback.
  \xlsfonts  |  \grep  --line-regexp  --quiet  vga
  if [[ $? -eq 1 ]]; then
    font="-*-fixed-medium-*-*-*-14-*-*-*-*-*-*-*"
  else
    font="vga"
  fi

  # Note that I am unable to do  \terminal  to guarantee I'm not bumping into an alias or the like.   So instead, I am using absolute paths.
  # TODO - expand this list.
  terminals_without_lines=(
    /usr/bin/evilvte
    /usr/bin/aterm
    /usr/bin/lxterminal
    /usr/bin/sakura
    /usr/bin/Terminal
  )

  terminals_with_lines=(
    /usr/bin/evilvte
    /usr/bin/lxterminal
    /usr/bin/sakura
    /usr/bin/Terminal
	)
}



determine_which_terminal_to_run(){
  determine_terminal_existance(){
    for i in $1; do
      # Trim whitespace.
      i=$( \echo  $i | \xargs )
      \which  $i > /dev/null
      if [ $? -eq 0 ]; then
        \echo  $i
        break
      fi
    done
  }

  if [[ "x$1" == "xwith_lines" ]]; then
    # Nuke $1
    shift
    determine_terminal_existance  $terminals_with_lines
  else
    determine_terminal_existance  $terminals_without_lines
  fi
}



launch_terminal(){
  if [[ x$1 == 'x' ]]; then
    \echo  "ERROR:  No valid terminal was found.  Edit this script to add one."
    \echo  "  \nano  $0"
    exit  1
  else
    \echo  "Running $1"
  fi

  case $1 in
    /usr/bin/evilvte)
      \eval  $terminal_to_run  $@
    ;;
    *)
      \echo foo
    ;;
  esac
}



terminal_setup
launch_terminal  $( determine_which_terminal_to_run )



exit 0
# ---
# ---
# ---
# EARLIER CODE WHICH IS HERE FOR REFERENCE AND WILL BE REPLACED
# ---
# ---
# ---




run_if_exists(){
  if [[ $( \which $1 ) != '' ]]; then
    $@ \
    &
    exit  0
  fi
}



# FIXME - before this commit were terminal multiplexer notes.  st doesn't support scrollback, so I need a multiplexer with one.
# TODO - customize tabbed:
#   Set a maximum tab width.
#   control-pageup/pagedown to change tabs
#   control-shift-pageup/pagedown to move a tab
#   control-t to spawn a new tab
#   alt-n to change to a specific tab
# TODO - fix the title

run_tabbed_st_if_they_exist(){
  \which \tabbed > /dev/null   ;   local  tabbed=$?   ;   if  [ $tabbed -ne 0 ]; then return 1; fi
  \which \st     > /dev/null   ;   local  st=$?       ;   if  [ $st     -ne 0 ]; then return 1; fi

  \which \screen > /dev/null   ;   local  screen=$?
  \which \tmux   > /dev/null   ;   local  tmux=$?
  if [ $screen -ne 0 ] && [ $tmux -ne 0 ]; then return 1; fi

  # TODO - Figure out which one I want by default.
  # TODO - I have notes on other terminal multiplexers.
  if [[ $screen -eq 0 ]]; then
    # https://www.gnu.org/software/screen/
    # TODO - customize the scrollback
    #   screen uses C-a ESC  --  This is the copy feature.  Sigh, GNU.
    local terminal_multiplexer=\screen
  elif [[ $tmux -eq 0 ]]; then
    # http://tmux.sourceforge.net/
    # TODO - customize the scrollback
    #   tmux uses C-b [
    local terminal_multiplexer=\tmux
  fi

  # These were erratic:
#  local  windowid=tabbed-$$
#  local  windowid=$( mktemp  --dry-run )
#  local  windowid=tabbed-$$-$( mktemp  --dry-run )
  # Imperfect, but it'll do.  Depends on GNU coreutils.
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



terminal_determination() {

  run_if_exists \
    \evilvte \
      $@

  # http://www.afterstep.org/aterm.php
  # Zero dependencies, from what I can tell.  Even xterm has a few, on Unity Linux.
  run_if_exists \
    \aterm \
      ` # Output to the window should not have it scroll to the bottom.` \
      -si \
      ` # No visual bell. ` \
      +vb \
      ` # No scrollbar. ` \
      +sb \
      ` # The default font can do fancy designs. ` \
      ` # -font default ` \
      ` # My font addition ` \
      -fn $font \
      -bg black \
      -fg gray \
      -cr darkgreen \
      -sl 10000 \
      -geometry 80x24+0+0 \
      $@

  # http://wiki.lxde.org/en/LXTerminal
  # http://sourceforge.net/projects/lxde/files/LXTerminal%20%28terminal%20emulator%29/
  # New tabs are opened in the same directory as the current tab.
  run_if_exists \
    \lxterminal \
      --geometry=80x24 \
      $@

  # http://pleyades.net/david/sakura.php
  # Tabbed
  # when using bash as the default shell, the prompt doesn't immediately appear.  zsh works fine.
  run_if_exists \
    \sakura \
      --geometry 80x24+1+1 \
      $@

  # http://invisible-island.net/xterm/
  run_if_exists \
    \xterm \
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
      $@

  # http://tools.suckless.org/tabbed/
  # http://st.suckless.org/
  # I do enjoy how lxterminal will spawn another terminal in the same directory.
  # screen is obnoxious to scroll back with.  It would have to be investigated before I would use it.
  run_tabbed_st_if_they_exist

  # TODO:  Website
  # Bloated, but at least it can use the default system fixed width font so it looks right.
  # Tabbed
  run_if_exists \
    \gnome-terminal \
      --geometry 80x24+0+0 \
      $@

  # TODO:  Website
  # Tabbed
  run_if_exists \
    \Terminal \
      --geometry 80x24+0+0 \
      $@

  # TODO:  Website
  # Tabbed
  run_if_exists \
    \terminal \
      --geometry 80x24+0+0 \
      $@

  # http://lilyterm.luna.com.tw/
  # Tabbed
  run_if_exists \
    \lilyterm \
      $@

  # http://materm.sourceforge.net/wiki/
  # (Formerly materm)
  # FIXME: my options from the Zaurus
  # Tabbed
  run_if_exists \
    \mrxvt \
      $@

  # Simple Terminal
  # http://st.suckless.org/
  # Not tabbed.  Supposedly tab-able using "tabbed" http://tools.suckless.org/tabbed/ but I can't get them to work together.
  # If I can tweak the font a little more, and get tabbing working, I think I would switch to this.
  run_if_exists \
    \st \
      $0

  # http://roxterm.sourceforge.net/
  # This term doesn't feel right
  # Tabbed
  run_if_exists \
    \roxterm \
      $@

  # http://software.jessies.org/terminator/
  # Tabbed
  # Holy shit, their geometry is pixel based, not character based like everyone else in the universe.
  #\terminator --geometry 80x24+0+0 $@
  run_if_exists \
    \terminator \
      --geometry +0+0 \
      $@

  # http://www.eterm.org/
  # Has dependencies.. I won't want to use it.
  #run_if_exists \
  #  \Eterm
}



# --
# -- Begin
# --

terminal_setup
# TODO:  This can be redone.  The knowledge of "with_lines-ness" can be moved up into the individual programs.
#   1) Each program can set a flag.
#   2) When referring to the programs, pass an option to require+execute with or without with_lines-ness.
#   It seems straightforward.. good luck, self!
if [[ "x$1" == "xwith_lines" ]]; then
  # Nuke $1
  shift
  run_if_exists  \evilvte    "$@"
  run_if_exists  \lxterminal "$@"
  run_if_exists  \sakura     "$@"
  run_if_exists  \Terminal   "$@"
fi

# If not specifying with_lines, or if none of the with_lines programs above actually exist, then attempt the whole list:
terminal_determination

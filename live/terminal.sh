#!/bin/bash

# Run through various terminals to find one that's installed.. '

# Not tabbed?  Use `screen`.  There's not much point for using screen locally, in a windowed environment, unless you're REALLY tight on memory.
#   `screen` screws up the scrollback.
#   one optimal usage might be:  screen -a -D -R -q -T term -h 1000 -x .. but I can't get this to work for me.
#   \xterm -fn vga -bg black -fg gray -cr darkgreen -sl 10000 -geometry 80x24+0+0 -e screen -q

# TODO:  Implement a universal parameter thingy, so that this script can be passed parameters and it will translate them into the appropriate format for each terminal.  This is necessary for universality.



terminal_setup() {
  # This fixes a GNOME hotkey issue which was starting the terminal in /  I don't know if this breaks any other usage!
  #\cd  ~

  # This was for Unity Linux, possibly for Ubuntu/Lubuntu, does not apply to Gentoo/Sabayon
  # Check for my favourite font, with a safe fallback.
  # Not sure why I originally used  DISPLAY=  here.
  #DISPLAY=:0.0  \xlsfonts  |  \grep  vga
  \xlsfonts  |  \grep  --line-regexp  --quiet  vga
  if [[ $? -eq 1 ]]; then
    font="-*-fixed-medium-*-*-*-14-*-*-*-*-*-*-*"
  else
    font="vga"
  fi
}



run_if_exists(){
  \which  $1  >  /dev/null
  if [[ $? -eq 0 ]]; then
    $@ \
    &
    exit  0
  fi
}



# TODO - I actually don't want to use a terminal multiplexer at all!
# TODO - customize tabbed:
#   control-pageup/pagedown to change tabs
#   control-shift-pageup/pagedown to move a tab
#   control-t to spawn a new tab
#   alt-n to change to a specific tab
run_tabbed_st_if_they_exist(){
  \which  \tabbed  >  /dev/null
  local  tabbed=$?
  \which  \st      >  /dev/null
  local  st=$?
  \which  \screen  >  /dev/null
  local  screen=$?
  \which  \tmux    >  /dev/null
  local  tmux=$?
  # TODO - Figure out which one I want by default.
  # TODO - I have notes on other terminal multiplexers.
  if   [[ $screen -eq 0 ]]; then
    # https://www.gnu.org/software/screen/
    local  terminal_multiplexer=\screen
  elif [[ $tmux   -eq 0 ]]; then
    # http://tmux.sourceforge.net/
    local  terminal_multiplexer=\tmux
  fi
  if [[ $tabbed -eq 0 && $st -eq 0 ]]; then
    \tabbed \
      -c     ` # Close tabbed when the last tab is closed. ` \
      -r 2 \
      \st \
        -w '' \
` #        -e $terminal_multiplexer ` \
    &
    exit  0
  fi
}



terminal_determination() {

  # http://tools.suckless.org/tabbed/
  # http://st.suckless.org/
  run_tabbed_st_if_they_exist

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

  # TODO:  Website
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
  run_if_exists  \lxterminal "$@"
  run_if_exists  \sakura     "$@"
  run_if_exists  \Terminal   "$@"
fi

# If not specifying with_lines, or if none of the with_lines programs above actually exist, then attempt the whole list:
terminal_determination

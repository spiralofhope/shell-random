# Run through various terminals to find one that's installed.. '

# Features?  We don't need no stinkin' features..

# Not tabbed?  Use `screen`.  Not much point in a windowed environment unless you're REALLY tight on memory.
#   screen screws up the scrollback.
#   one optimal usage might be:  screen -a -D -R -q -T term -h 1000 -x .. but I can't get this to work for me.
#   \xterm -fn vga -bg black -fg gray -cr darkgreen -sl 10000 -geometry 80x24+0+0 -e screen -q

# TODO:  Implement a universal parameter thingy, so that this script can be passed parameters and it will translate them into the appropriate format for each terminal.  This is necessary for universality, and also since Openbox does not allow --parameter (two dashes) in it's rc.xml .. sad.

# This fixes a GNOME hotkey issue which was starting the terminal in /  I don't know if this breaks any other usage!
cd ~


  # http://www.afterstep.org/aterm.php
  # Zero dependencies, from what I can tell.  Even xterm has a few, on Unity Linux.
  \aterm \
      ` # Output to the window should not have it scroll to the bottom.` \
    -si \
      ` # No visual bell. ` \
    +vb \
      ` # No scrollbar. ` \
    +sb \
      ` # My font addition ` \
      ` # -font default    <- that's able to do the fancy designs. ` \
    -fn vga \
    -bg black \
    -fg gray \
    -cr darkgreen \
    -sl 10000 \
    -geometry 80x24+0+0 \
    $@

if [ $? -eq 127 ]; then
  \lxterminal \
    --geometry=80x24 \
    $@
fi

if [ $? -eq 127 ]; then
  # http://invisible-island.net/xterm/
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
    -fn vga \
      ` # xterm should assume that the normal and bold fonts have VT100 line-drawing characters.  It sets the forceBoxChars resource to "true". ` \
    +fbx \
    -bg black \
    -fg gray \
    -cr darkgreen \
    -sl 10000 \
    -geometry 80x24+0+0 \
    $@
fi

if [ $? -eq 127 ]; then
  # http://pleyades.net/david/sakura.php
  # Tabbed
  # when using bash as the default shell, the prompt doesn't immediately appear.  zsh works fine.
  \sakura --geometry 80x24+1+1 $@
fi

if [ $? -eq 127 ]; then
  # Bloated, but at least it can use the default system fixed width font so it looks right.
  # Tabbed
  \gnome-terminal --geometry 80x24+0+0 $@
fi

if [ $? -eq 127 ]; then
  # Tabbed
  \Terminal --geometry 80x24+0+0 $@
fi

if [ $? -eq 127 ]; then
  # Tabbed
  \terminal --geometry 80x24+0+0 $@
fi

if [ $? -eq 127 ]; then
  # http://lilyterm.luna.com.tw/
  # Tabbed
  \lilyterm $@
fi

if [ $? -eq 127 ]; then
  # http://materm.sourceforge.net/wiki/
  # (Formerly materm)
  # FIXME: my options from the Zaurus
  # Tabbed
  \mrxvt $@
fi

if [ $? -eq 127 ]; then
  # http://roxterm.sourceforge.net/
  # This term doesn't feel right
  # Tabbed
  \roxterm $@
fi

if [ $? -eq 127 ]; then
  # http://software.jessies.org/terminator/
  # Tabbed
  # Holy shit, their geometry is pixel based, not character based like everyone else in the universe.
  #\terminator --geometry 80x24+0+0 $@
  \terminator --geometry +0+0 $@
fi

# http://www.eterm.org/
# Has dependencies.. I won't want to use it.
# Eterm

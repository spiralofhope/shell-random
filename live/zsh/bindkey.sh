#!/usr/bin/env  zsh
# If you have line ending problems with this file (references to ^M) then do:
# \sed  --in-place 's/\r//' bindkey.sh
# full of zshisms, obviously.
# shellcheck disable=2039
# NOTE: control-v and a key combination to learn that binding.
# Raw characters for reference:    
# You can also insert raw characters with:
# 1.  echo '
# 2.  control-v
# 3.  (press your key combination)
# 4.  ' >> bindkeys.sh



:<<IDEAS
# TODO - Where is this fron?
if [ -f ~/.zkbd/$TERM-$VENDOR-$OSTYPE ]; then
  source ~/.zkbd/$TERM-$VENDOR-$OSTYPE
  [[ -n ${key[Backspace]} ]] && bindkey  "${key[Backspace]}" backward-delete-char
  [[ -n ${key[Home]}      ]] && bindkey  "${key[Home]}"      beginning-of-line
  [[ -n ${key[Delete]}    ]] && bindkey  "${key[Delete]}"    delete-char
  [[ -n ${key[End]}       ]] && bindkey  "${key[End]}"       end-of-line
  [[ -n ${key[PageUp]}    ]] && bindkey  "${key[PageUp]}"    up-line-or-history
  [[ -n ${key[PageDown]}  ]] && bindkey  "${key[PageDown]}"  down-line-or-history
  [[ -n ${key[Up]}        ]] && bindkey  "${key[Up]}"        up-line-or-search
  [[ -n ${key[Up]}        ]] && bindkey  "${key[Up]}"        up-line-or-search
  [[ -n ${key[Left]}      ]] && bindkey  "${key[Left]}"      backward-char
  [[ -n ${key[Down]}      ]] && bindkey  "${key[Down]}"      down-line-or-search
  [[ -n ${key[Right]}     ]] && bindkey  "${key[Right]}"     forward-char
else
IDEAS



# To erase all existing bindkeys
  # Zefram <zefram@xxxxxxxx>
  # http://www.zsh.org/mla/users/2000/msg00180.html
  #   You almost certainly don't want to delete keymap main.  To create a
  #   completely new keymap, create one with "bindkey  -N", giving it a new name,
  #   then you can add to it as much as you want while it's not selected.
  #   *Then* use "bindkey  -A" to make "main" a link to your new keymap.
  #   (And presuming that you want to save the keymap permanently, use "bindkey -L"
  #   to dump the keymap in the form of the commands needed to poulate it.)
# bindkey  -N    foo  .safe
# bindkey  -A    foo  main
# bindkey  -L
# bindkey  -R    "^@"-"^I"      self-insert
# bindkey  "^J"  accept-line
# bindkey  -R    "^K"-"^L"      self-insert
# bindkey  "^M"  accept-line
# bindkey  -R    "^N"-"\M-^?"   self-insert



# key bindings
# A decent set..
typeset  -g  -A  key



# These notes are old.  things seem to be different now:
# FIXME - alt-backspace and ^backspace are both the same!
# So maybe somehow rig a function up to the backspace key to use some external program which can see if alt/ctrl were held down?
# Or better yet, I think I can have ~/.Xresources specify what the key does.  At the tty, control-backspace is ^_, which is different from X.  Maybe I can force a different keycode to pop out with control-backspace in an xterm, and then I can have zsh pick that up and use it.  Check out the bottom of http://zshwiki.org/home/zle/bindkeys
# Also consider control-shift-backspace to delete to the beginning of the line

# I've uncommented only the things I required.  The above typeset seems to be good for most things.

#\bindkey  '^?'       backward-delete-char                               # backspace
#\bindkey  '^[[D'     backward-char                                      # left
#\bindkey  '^[[C'     forward-char                                       # right
#\bindkey  '^[[A'     up-line-or-history                                 # up
#\bindkey  '^[[B'     down-line-or-history                               # down

\bindkey  '^[[3~'    delete-char                                        # delete

# (old binding)
#\bindkey  '^[[5~'    up-line-or-search                                  # pageup (matching history)
#\bindkey  '^[[6~'    down-line-or-search                                # pagedown (matching history)
# These should properly go through history:
\bindkey  '^[[5~'    history-beginning-search-backward                  # pageup (matching history)
\bindkey  '^[[6~'    history-beginning-search-forward                   # pagedown (matching history)

\bindkey  '^[[1;5D'  backward-word                                      # control-left
\bindkey  '^[[1;5C'  forward-word                                       # control-right

#\bindkey  '^[[3;5~'  kill-word                                          # control-delete
\bindkey  '^[[3^'  kill-word                                            # control-delete


# alt-backspace appears to be impossible
# I hear that xterm can be configured with changes in ~/.Xresources, but I have no will to pursue any of this.
#\bindkey  '^È'       backward-kill-word                                 # alt-backspace
#\bindkey  '^[^?'     vi-backward-kill-word                              # alt-backspace

# kill-word does not respect word bounderies.
#\bindkey  '^[[3;3~'  kill-word
#\bindkey  '^[[3;5~'  delete-word-forward                                # alt-delete

{  #  Tab completion
  # TODO - Explore listing the possible matches as one single-column where possible.  There's nothing built-in, but it's possible to associate a method to the completion functionality.

  # menu-complete
  #   Pressing tab immediately suggests the full command line.
  #   When the user types something partial, pressing tab immediately cycles through suggested matches.
  \bindkey   '^[[Z'      reverse-menu-complete                          # shift-tab (go back in the list of tab autocompletion items)
}


{  #  Quote everything after the first parameter
  # TODO - This turns the mark on, and it shouldn't.  I wasn't able to figure out how to stop that, but I don't care much.
  # Use case:
  #   somecommand
  #   (paste)
  #   somecommand This is a string
  #   ^X
  #   somecommand 'This is a string'
  \bindkey  -s  '^X'  '^@^[[1;5C^A\ef\e" ^@'                            # control-x
}


# Respect word bounderies with:
# vi-backward-word
# vi-forward-word
# vi-backward-kill-word
# There is no vi-kill-word ..  =/



# This seems to be the Right Way to handle edge cases
case "$TERM" in

  xterm-256color       |\
  screen.xterm-256color)
    \bindkey  '^[[H'     beginning-of-line                              # home
    \bindkey  '^[[F'     end-of-line                                    # end
    \bindkey  '[3;5~'  delete-word                                   # control-delete
    \bindkey  '[3;3~'  delete-word                                   # alt-delete
    case "${this_kernel_release:?}" in
      'Cygwin')
        #  2017-11-07 - Babun (though with a Cygwyn update)
        \bindkey  '^_'       backward-kill-word                         # control-backspace
      ;;
      'Windows Subsystem for Linux')
        #  2020-04-18
        \bindkey  '^H'       backward-kill-word                         # control-backspace
      ;;
      'Windows Subsystem for Linux 2')
        #  TODO - test
        \bindkey  '^H'       backward-kill-word                         # control-backspace
      ;;
    esac
  ;;

  rxvt-unicode         |\
  rxvt-unicode-256color)
    # rxvt-unicode = 'urxvt' (urxvtd / urxvtc)
    \bindkey  '^[[7~'    beginning-of-line                              # home
    \bindkey  '^[[8~'    end-of-line                                    # end
    #\bindkey  '^H'       backward-kill-word                             # control-backspace
    # 2016-11-26 - Devuan
    \bindkey  ''       backward-kill-word                             # control-backspace
  ;;

  linux)   # The raw tty console
    # At the raw console, `control-left` / `control-right` are somehow the same as `left` / `right`
    #   I won't use alt-left / alt-right since that changes raw tty consoles quickly, which is nice sometimes.
#    \bindkey  '^[OH'     beginning-of-line                              # home
#    \bindkey  '^[OF'     end-of-line                                    # end
#    \bindkey  '[D'     backward-char                                  # left
#    \bindkey  '[C'     forward-char                                   # right
    # `delete` and `alt-delete` are somehow the same.
#    \bindkey  '^[[3~'    delete-char                                    # delete
  ;;

  screen         |\
  screen-256color)   # The program 'screen'
    # Even in screen, at the raw console, `control-left` / `control-right` are somehow the same as `left` / `right`
#    \bindkey  '[D'      backward-char                                 # left
#    \bindkey  '[C'      forward-char                                  # right
#    \bindkey  'OD'      backward-word                                 # control-left
#    \bindkey  'OC'      forward-word                                  # control-right
#    \bindkey  '^?'        backward-delete-char                          # backspace
#    \bindkey  '^[[3~'     delete-char                                   # delete
#    \bindkey  '[3;5~'   delete-word                                   # control-delete
#    \bindkey  '[3;3~'   delete-word                                   # alt-delete
#    \bindkey  '^[[1~'     beginning-of-line                             # home
#    \bindkey  '^[[4~'     end-of-line                                   # end
  ;;

  screen.linux)   # The program 'screen', at the tty
# These won't work, because left/right are the same as control-left/right !
#    \bindkey '^[OD'      backward-word                                  # control-left
#    \bindkey '^[OC'      forward-word                                   # control-right
#    \bindkey  '^H'       backward-kill-word                             # alt-backspace
  ;;

  *xterm*)  # Anything similar that's left..
    #\bindkey  '^?'       backward-kill-word                             # control-backspace
    \bindkey  '^[[H'     beginning-of-line                              # home
    \bindkey  '^[[F'     end-of-line                                    # end

    # 2016-11-26 - Devuan
    \bindkey  '^H'       backward-kill-word                             # control-backspace
    \bindkey  'ÿ'        backward-kill-word                             # alt-backspace
    \bindkey  '^?'       backward-delete-char                           # backspace
  ;;

  *)
    \echo
    # shellcheck disable=2016
    \echo  'WARNING:  This $TERM edge case has not been planned-for: '  "$TERM"
    \echo  "  To add support, edit:"
    \echo  "  $( \realpath  "$0" )"
    \echo
  ;;
esac

# Note that `bindkey` is a zshism
# NOTE: It's control-v and a key combination to learn the binding.



:<<IDEAS
if [ -f ~/.zkbd/$TERM-$VENDOR-$OSTYPE ]; then
  source ~/.zkbd/$TERM-$VENDOR-$OSTYPE
  [[ -n ${key[Backspace]} ]] && bindkey  "${key[Backspace]}" backward-delete-char
  [[ -n ${key[Home]} ]] && bindkey  "${key[Home]}" beginning-of-line
  [[ -n ${key[Delete]} ]] && bindkey  "${key[Delete]}" delete-char
  [[ -n ${key[End]} ]] && bindkey  "${key[End]}" end-of-line
  [[ -n ${key[PageUp]} ]] && bindkey  "${key[PageUp]}" up-line-or-history
  [[ -n ${key[PageDown]} ]] && bindkey  "${key[PageDown]}" down-line-or-history
  [[ -n ${key[Up]} ]] && bindkey  "${key[Up]}" up-line-or-search
  [[ -n ${key[Up]} ]] && bindkey  "${key[Up]}" up-line-or-search
  [[ -n ${key[Left]} ]] && bindkey  "${key[Left]}" backward-char
  [[ -n ${key[Down]} ]] && bindkey  "${key[Down]}" down-line-or-search
  [[ -n ${key[Right]} ]] && bindkey  "${key[Right]}" forward-char
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
# Or better yet, I think I can have ~/.Xresources specify what the key does.  At the console, control-backspace is ^_, which is different from X.  Maybe I can force a different keycode to pop out with control-backspace in an xterm, and then I can have zsh pick that up and use it.  Check out the bottom of http://zshwiki.org/home/zle/bindkeys
# Also consider control-shift-backspace to delete to the beginning of the line

# I've uncommented only the things I required.  The above typeset seems to be good for most things.

#bindkey  '^?'       backward-delete-char                                # backspace
#bindkey  '^[[D'     backward-char                                       # left
#bindkey  '^[[C'     forward-char                                        # right
#bindkey  '^[[A'     up-line-or-history                                  # up
#bindkey  '^[[B'     down-line-or-history                                # down

bindkey  '^[[3~'    delete-char                                         # delete

# (old binding)
#bindkey  '^[[5~'    up-line-or-search                                   # pageup (matching history)
#bindkey  '^[[6~'    down-line-or-search                                 # pagedown (matching history)
# These should properly go through history:
bindkey  '^[[5~'    history-beginning-search-backward                   # pageup (matching history)
bindkey  '^[[6~'    history-beginning-search-forward                    # pagedown (matching history)

bindkey  '^[[1;5D'  backward-word                                       # control-left
bindkey  '^[[1;5C'  forward-word                                        # control-right

bindkey  '^[[3;5~'  kill-word                                           # control-delete

# alt-backspace appears to be impossible
# I hear that xterm can be configured with changes in ~/.Xresources, but I have no will to pursue any of this.
#bindkey  '^È'       backward-kill-word                                  # alt-backspace
#bindkey  '^[^?'     vi-backward-kill-word                               # alt-backspace

# kill-word does not respect word bounderies.
#bindkey  '^[[3;3~'  kill-word
#bindkey  '^[[3;5~'  delete-word-forward                                 # alt-delete


# Quote everything after the first parameter:
# TODO - This turns the mark on, and it shouldn't.  I wasn't able to figure out how to stop that, but I don't care much.
# Use case
#   somecommand 
#   (paste)
#   somecommand This is a string
#   ^X
#   somecommand 'This is a string'
bindkey  -s  '^X'  '^@^[[1;5C^A\ef\e" ^@'                               # control-x


# Respect word bounderies with:
# vi-backward-word 
# vi-forward-word
# vi-backward-kill-word
# There is no vi-kill-word ..  =/



# This seems to be the Right Way to handle edge cases
case $TERM in
  xterm)
    bindkey  '^?'       backward-kill-word                                  # control-backspace
    bindkey  '^[[H'     beginning-of-line                                   # home
    bindkey  '^[[F'     end-of-line                                         # end
  ;;

  rxvt-unicode-256color)
    bindkey  '^[[7~'    beginning-of-line                                   # home
    bindkey  '^[[8~'    end-of-line                                         # end
    bindkey  '^H'       backward-kill-word                                  # control-backspace
  ;;

  linux)
    bindkey  '^[OH'     beginning-of-line                                   # home
    bindkey  '^[OF'     end-of-line                                         # end
    bindkey  '^H'       backward-kill-word                                  # control-backspace
  ;;
  
  screen|screen-256color)
    bindkey  '^?'       backward-delete-char                                # backspace
    bindkey  '^[[1~'    beginning-of-line                                   # home
    bindkey  '^[[4~'    end-of-line                                         # end
    bindkey  '^H'       backward-kill-word                                  # control-backspace
  ;;

  *)
    echo 'WARNING:  This $TERM edge case has not been planned-for: ' $TERM
  ;;
esac

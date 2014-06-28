# FIXME? - This was noted as being broken under aterm.
#   1) Who cares about aterm
#   2) Is it actually broken under my current term(s)?



:<<IDEAS
if [ -f ~/.zkbd/$TERM-$VENDOR-$OSTYPE ]; then
  source ~/.zkbd/$TERM-$VENDOR-$OSTYPE
  [[ -n ${key[Backspace]} ]] && bindkey  "${key[Backspace]}" backward-delete-char
  [[ -n ${key[Home]} ]] && bindkey  "${key[Home]}" beginning-of-line
  [[ -n ${key[PageUp]} ]] && bindkey  "${key[PageUp]}" up-line-or-history
  [[ -n ${key[Delete]} ]] && bindkey  "${key[Delete]}" delete-char
  [[ -n ${key[End]} ]] && bindkey  "${key[End]}" end-of-line
  [[ -n ${key[PageDown]} ]] && bindkey  "${key[PageDown]}" down-line-or-history
  [[ -n ${key[Up]} ]] && bindkey  "${key[Up]}" up-line-or-search
  [[ -n ${key[Up]} ]] && bindkey  "${key[Up]}" up-line-or-search
  [[ -n ${key[Left]} ]] && bindkey  "${key[Left]}" backward-char
  [[ -n ${key[Down]} ]] && bindkey  "${key[Down]}" down-line-or-search
  [[ -n ${key[Right]} ]] && bindkey  "${key[Right]}" forward-char
else
IDEAS



# NOTE: It's control-v and a key combination to learn the binding.

# Erase all existing bindkeys with:
# bindkey  -N    foo  .safe
# bindkey  -A    foo  main
# bindkey  -L
# bindkey  -R    "^@"-"^I"      self-insert
# bindkey  "^J"  accept-line
# bindkey  -R    "^K"-"^L"      self-insert
# bindkey  "^M"  accept-line
# bindkey  -R    "^N"-"\M-^?"   self-insert



# Zefram <zefram@xxxxxxxx>
# http://www.zsh.org/mla/users/2000/msg00180.html
#   You almost certainly don't want to delete keymap main.  To create a
#   completely new keymap, create one with "bindkey  -N", giving it a new name,
#   then you can add to it as much as you want while it's not selected.
#   *Then* use "bindkey  -A" to make "main" a link to your new keymap.
#   (And presuming that you want to save the keymap permanently, use "bindkey -L"
#   to dump the keymap in the form of the commands needed to poulate it.)



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
bindkey  '^[OH'     beginning-of-line                                   # home
bindkey  '^[OF'     end-of-line                                         # end
bindkey  '^[[5~'    up-line-or-search                                   # pageup (matching history)
bindkey  '^[[6~'    down-line-or-search                                 # pagedown (matching history)
# vi-backward-word would respect word bounderies.
bindkey  '^[[1;5D'  backward-word                                       # control-left
# vi-forward-word would respect word bounderies.
bindkey  '^[[1;5C'  forward-word                                        # control-right
# vi-backward-kill-word would respect word bounderies.
bindkey  '^H'       backward-kill-word                                  # control-backspace
# There is no vi-kill-word ..  =/
bindkey  '^[[3;5~'  kill-word                                           # control-delete

# alt-backspace - impossible
#bindkey  '^[^?'     vi-backward-kill-word
# kill-word does not respect word bounderies.
#bindkey  '^[[3;3~'  kill-word
#bindkey  '^[[3;5~'  delete-word-forward                                 # alt-delete

# Quote everything after the first parameter:
# TODO - This turns the mark on, and it shouldn't.  I wasn't able to figure out how to stop that, but I don't care much.
bindkey  -s  '^X'  '^@^[[1;5C^A\ef\e" ^@'                               # control-x

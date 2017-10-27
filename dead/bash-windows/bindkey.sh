#!/usr/bin/env  bash
# TODO -- This is from mysysgit.


# bind -P  will display the list of bindings
# These seem to be default.
# arrow up
#bind  "\e[5~":  history-search-backward
# arrow down
#bind  "\e[B":   history-search-forward

# TODO - I can't figure out how to use pageup/pagedown
# page up
#bind  "\e[A":   history-search-backward
# page down
#bind  "\e[6~":  history-search-forward
#bind  "\e[A": history-search-backward
# fucks up the use of 'b'
#bind  "\e[B": history-search-forward
#bind  '"\e[A":history-search-backward'
#bind  '"\e[B":history-search-forward'

#bind  "\e[A":   previous-history
#bind  "\e[6~":      next-history



# --
# -- Tab completion
# --

set  show-all-if-ambiguous on 
set  completion-ignore-case on

# Pressing tab immediately suggests the full command line.
# When the user types something partial, pressing tab immediately cycles through suggested matches.
bind  '"\t":  menu-complete'
# TODO - Explore shift-tab to go backwards in history
# TODO - Explore tab also listing the possible matches
# TODO - Explore listing the possible matches as one single-column where possible.  There's nothing built-in, but it's possible to associate a method to the completion functionality.



# --
# -- TODO - control-left/right
# --
#bind  "\e[1;5C": forward-word
#bind  "\e[1;5D": backward-word
#bind  "\e[5C": forward-word
#bind  "\e[5D": backward-word
#bind  "\e\e[C": forward-word
#bind  "\e\e[D": backward-word
#bind  '"\e\x5b\x31\x3b\x35\x44"':backward-word
#bind  '"\e\x5b\x31\x3b\x35\x43"':forward-word

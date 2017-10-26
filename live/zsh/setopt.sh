#!/usr/bin/env  zsh
# Note that `setopt` is a zshism



# ZSH Options
#   http://zsh.sourceforge.net/Doc/Release/Options.html

# --
# --  autoload
# --

# Command completion
# I don't know what -Uz does, and I didn't find quick docs on it, but this was elsewhere and is getting deleted.
#autoload  -Uz  compinit
autoload  -U  compinit
compinit

autoload  -U  colors
colors

# Magically quote content in URLs, like ( and &
autoload  -U  url-quote-magic
zle  -N  self-insert  url-quote-magic



# --
# --  setopt:  Changing Directories
# --

# allow one to change to a directory by entering it as a command
setopt  auto_cd

# automatically append dirs to the push/pop list
setopt  auto_pushd

# Don't duplicate auto_pushd
setopt  pushd_ignore_dups

# Exchanges the meanings of ‘+’ and ‘-' when used with a number to specify a directory in the stack. 
setopt  pushd_minus

# Have pushd with no arguments act like ‘pushd $HOME’.
setopt  pushd_to_home

# Do not print the directory stack after pushd or popd. 
setopt  pushd_silent



# --
# --  setopt:  Completion
# --

# Completion is done on both ends of the word.
setopt  complete_in_word

# When completing from middle, move the cursor to the end.
setopt  always_to_end

# Automatically list choices on an ambiguous completion. 
setopt  auto_list

# If a parameter is completed whose content is the name of a directory, then add a trailing slash instead of a space. 
setopt  auto_param_slash

# When the current word has a glob pattern, do not insert all the words resulting from the expansion but generate matches as for completion and cycle through them like MENU_COMPLETE. The matches are generated as if a ‘*’ was added to the end of the word, or inserted at the cursor when COMPLETE_IN_WORD is set. This actually uses pattern matching, not globbing, so it works not only for files but for any completion, such as options, user names, etc.
# Note that when the pattern matcher is used, matching control (for example, case-insensitive or anchored matching) cannot be used. This limitation only applies when the current word contains a pattern; simply turning on the GLOB_COMPLETE option does not have this effect. 
setopt  glob_complete

# On an ambiguous completion, instead of listing possibilities or beeping, insert the first match immediately. Then when completion is requested again, remove the first match and insert the second match, etc. When there are no more matches, go back to the first one again. reverse-menu-complete may be used to loop through the list in the other direction. This option overrides AUTO_MENU. 
setopt  menu_complete



# --
# --  setopt:  Expansion and Globbing
# --

# Make globbing (filename generation) sensitive to case. Note that other uses of patterns are always sensitive to case.
# If the option is unset, the presence of any character which is special to filename generation will cause case-insensitive matching.
# For example, cvs(/) can match the directory CVS owing to the presence of the globbing flag (unless the option BARE_GLOB_QUAL is unset). 
setopt  no_case_glob

# Make regular expressions using the zsh/regex module (including matches with =~) sensitive to case. 
setopt  no_case_match

# Perform filename generation (globbing).
setopt  glob

# Append a trailing ‘/’ to all directory names resulting from filename generation (globbing). 
setopt  mark_dirs

# Try to avoid the message:  'zsh: no matches found...'
# If a pattern for filename generation has no matches, print an error, instead of leaving it unchanged in the argument list.
# This also applies to file expansion of an initial ‘~’ or ‘=’. 
setopt  no_nomatch



# --
# --  setopt:  History
# --

# If this is set, zsh sessions will append their history list to the history file, rather than replace it. Thus, multiple parallel zsh sessions will all have the new entries from their history lists added to the history file, in the order that they exit. The file will still be periodically re-written to trim it when the number of lines grows 20% beyond the value specified by $SAVEHIST (see also the HIST_SAVE_BY_COPY option).
setopt  append_history

# When writing out the history file, by default zsh uses ad-hoc file locking to avoid known problems with locking on some operating systems. With this option locking is done by means of the system’s fcntl call, where this method is available. On recent operating systems this may provide better performance, in particular avoiding history corruption when files are stored on NFS. 
# I won't be using zsh elsewhere.
setopt  hist_fcntl_lock

# When searching for history entries in the line editor, do not display duplicates of a line previously found, even if the duplicates are not contiguous. 
setopt  hist_find_no_dups

# If a new command line being added to the history list duplicates an older one, the older command is removed from the list (even if it is not the previous event). 
setopt  hist_ignore_all_dups

# Remove command lines from the history list when the first character on the line is a space, or when one of the expanded aliases contains a leading space. Only normal aliases (not global or suffix aliases) have this behaviour. Note that the command lingers in the internal history until the next command is entered before it vanishes, allowing you to briefly reuse or edit the line. If you want to make it vanish right away without entering another command, type a space and press return. 
setopt  no_hist_ignore_space

# If a new command line being added to the history list duplicates an older one, the older command is removed from the list (even if it is not the previous event).
setopt  hist_save_no_dups

# This options works like APPEND_HISTORY except that new history lines are added to the $HISTFILE incrementally (as soon as they are entered), rather than waiting until the shell exits. The file will still be periodically re-written to trim it when the number of lines grows 20% beyond the value specified by $SAVEHIST (see also the HIST_SAVE_BY_COPY option).
setopt  inc_append_history

# Use the same history file for all sessions
setopt  share_history



# --
# --  setopt:  Initialization
# --



# --
# --  setopt:  Input/Output
# --

# Allows ‘>’ redirection to truncate existing files, and ‘>>’ to create files.
# Otherwise ‘>!’ or ‘>|’ must be used to truncate a file, and ‘>>!’ or ‘>>|’ to create a file. 
setopt  no_clobber

# Try to correct the spelling of commands. Note that, when the HASH_LIST_ALL option is not set or when some directories in the path are not readable, this may falsely report spelling errors the first time some commands are used.
# The shell variable CORRECT_IGNORE may be set to a pattern to match words that will never be offered as corrections. 
setopt  correct

# Try to correct the spelling of all arguments in a line. 
setopt  correct_all

# Let me paste a script and have zsh ignore comments.  Duh.
setopt  interactive_comments

# Print the exit value of programs with non-zero exit status.
setopt  print_exit_value

# Do not query the user before executing ‘rm *’ or ‘rm path/*’.
setopt  no_rm_star_silent

# Allow the short forms of for, repeat, select, if, and function constructs. 
setopt  short_loops



# --
# --  setopt:  Job Control
# --

# With this option set, stopped jobs that are removed from the job table with the disown builtin command are automatically sent a CONT signal to make them running. 
setopt  auto_continue

# Send the HUP signal to running jobs when the shell exits.
setopt  no_hup

# List jobs in the long format by default. 
setopt  long_list_jobs



# --
# --  setopt:  Prompting
# --



# --
# --  setopt:  Scripts and Functions
# --



# --
# --  setopt:  Shell Emulation
# --

# Causes field splitting to be performed on unquoted parameter expansions.
# Note that this option has nothing to do with word splitting.
setopt  sh_word_split



# --
# --  setopt:  Shell State
# --



# --
# --  setopt:  ZLE
# --

# Beep on error in ZLE.
# OH HELL NO
setopt  no_beep

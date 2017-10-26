# Windows file locking will hit $HISTFILE, causing a new shell to freeze on startup.

unsetopt inc_append_history
unsetopt share_history

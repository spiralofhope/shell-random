#!/usr/bin/env  zsh




{   # Find all characters after.

# After the first occurrance
string="test test"
pattern="s"

\echo ${string#*${pattern}}

# ----

# After the last occurrance
string="test test"
pattern="s"

\echo ${string##*${pattern}}

}

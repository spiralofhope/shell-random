#!/usr/bin/env  zsh




{   # Find all characters after.

# After the first occurrance
variable="test test"
pattern="s"

\echo ${variable#*${pattern}}

# ----

# After the last occurrance
variable="test test"
pattern="s"

\echo ${variable##*${pattern}}

}

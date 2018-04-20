#!/usr/bin/env  sh



# You need to use an external program like:
\expr  "1 + 1"

\echo  "1 + 1" | \bc

# For more complex things
\echo  "10 / 3" | \bc  --mathlib


# More is possible with awk

#!/usr/bin/env  sh


# This functionality not be available in all shells:
\echo  $(( 1 + 1 ))


# Using `expr`:
\expr  "1 + 1"


# Using `bc`:
\echo  "1 + 1"  | \bc
# Using `bc` for more complex math:
\echo  "10 / 3" | \bc  --mathlib


# TODO - More is possible with awk

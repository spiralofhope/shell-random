#!/usr/bin/env  bash

# if/then/else, elseif, case



# GNU bash, version 4.3.30(1)-release (i586-pc-linux-gnu)
stringa="something" ; stringb="something else"
# some earlier version:
# if [ ! "$stringa" = $stringb ]; then echo not equal ; fi
if [[ ! "$stringa" = $stringb ]]; then echo not equal ; fi


# GNU bash, version 4.3.30(1)-release (i586-pc-linux-gnu)
for i in *; do cd $i; unrar x -y filename1${i}.rar ; unrar x -y "filename 2 #${i}.rar" ; cd -; done


# FIXME - this needs example code
# $1 $2 $3 $4 $5 $6 $7 $8 $9 ${10} ${11} ${12} ${13} ${14} ... or $@



#!/bin/bash
# btrfs-undelete
# Copyright (C) 2013 Jörg Walter <info@syntax-k.de>
# This program is free software; you can redistribute it and/or modify it under
# the term of the GNU General Public License as published by the Free Software
# Foundation; either version 2 of the License, or any later version.

if [ ! -b "$1" -o -z "$2" ]; then
	echo "Usage: $0 <dev> <file/dir>" 1>&2
	echo
	echo "This program tries to recover the most recent version of the"
	echo "given file or directory (recursively)"
	echo
	echo "<dev> must not be mounted, otherwise this program may appear"
	echo "to work but find nothing."
	echo
	echo "<file/dir> must be specified relative to the filesystem root,"
	echo "obviously. It may contain * and ? as wildcards, but in that"
	echo "case, empty files might be 'recovered'. If <file/dir> is a"
	echo "single file name, this program tries to recover the most"
	echo "recent non-empty version of the file."
	echo
	echo "Note that files are restored to a temporary subdirectory"
	echo "below /tmp, so you probably don't want to restore huge file"
	echo "trees unless your /tmp has enough free space."
	exit 1
fi
dir="`dirname "$0"`"
dev="$1"
file="$2"

file="${file#/}"
file="${file%/}"
regex="${file//\\/\\\\}"

# quote regex special characters
regex="${regex//./\.}"
regex="${regex//+/\+}"
regex="${regex//|/\|}"
regex="${regex//(/\(}"
regex="${regex//)/\)}"
regex="${regex//\[/\[}"
regex="${regex//]/\]}"
regex="${regex//\{/\{}"
regex="${regex//\}/\}}"

# treat shell wildcards specially
nowild="$regex"
regex="${regex//\*/.*}" 
regex="${regex//\?/.}"
test "$nowild" != "$regex"
nowild=$?

# extract number of slashes in order to get correct number of closing parens
slashes="${regex//[^\/]/}"

# build final regex
regex="^/(|${regex//\//(|/}(|/.*${slashes//?/)}))\$" 

roots=/tmp/btrfs-undelete.$$.lst
out=/tmp/btrfs-undelete.$$

trap "rm $roots" EXIT
trap "rm -r $out &> /dev/null; exit 1" SIGINT

echo -ne "Searching roots..."
"$dir"/find-root /dev/mapper/queen-home 2>&1 \
	| grep ^Well \
	| sed -e 's/Well block \(.*\) seems.*, have=\(.*\), want=/\2 \1 /'  \
	| sort -n > $roots || exit 1

i=0
max="$(wc -l $roots)"
max="${max%% *}"
echo " found $max roots."

while [ "$i" -lt "$max" ]; do
	((i+=1))
	echo -ne "Trying root $i...\r"
	tail -n $i $roots | {
		read x id y
		rm -r $out
		mkdir $out
		"$dir/restore" -i -t $id -m "$regex" "$dev" $out
	} &> /dev/null
	if [ "$?" = 0 ]; then
		if [ "$nowild" = 1 ]; then
			if [ -s "$out/$file" -o -d "$out/$file" ]; then
				echo "Recovered file '$out/$file' from root $i".
				exit 0
			fi
		else
			if ls "$out/"${file// /\ } &> /dev/null; then
				echo "Recovered file(s) '$out/$file' from root $i".
				exit 0
			fi
		fi
	fi
done
rm -r $out
echo "Didn't find '$file'"
exit 1

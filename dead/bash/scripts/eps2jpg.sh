#!/bin/bash
# shellcheck disable=1001
# shellcheck disable=1012
#
# Converts Encapsulated PostScript (.eps) files to JPEG (.jpeg), while
# respecting the bounding box.
#
# Uses Ghostscript.
#
# Wouter Kager, 2004/05/23
#   https://www.few.vu.nl/~wkager/tools.htm
# edited by spiralofhope



gsopts='-q -dMaxBitmap=300000000 -dSAFER -dNOPAUSE -dBATCH'
forced='n'
distres='600'
mode='gray'


program="$( \basename  "$0" )"
\echo  "$program 2004/05/23 by Wouter Kager"


# Scan command line options.
while getopts "Cd:f" optionkey "$@"; do
	case $optionkey in
		C)	mode='' ;;
		d)	distres="$OPTARG" ;;
		f)	forced='y' ;;
		:)
      \echo  "$program:  The option -$OPTARG requires an argument!"
			\echo  "$program:  Run $program without arguments for help"
			exit  1 ;;
		?)
      \echo  "$program:  The option -$OPTARG is illegal!"
			\echo  "$program:  Run $program without arguments for help"
			exit  1 ;;
	esac
done


# Shift away the specified options.
shift $(( OPTIND - 1 ))


# Check if we have received any input files.
if [ $# -eq 0 ]; then
	cat <<-EOF
		Usage:  $program [options] file(s)
		
		The valid options are:
		 -C           color mode (default=gray)
		 -d res       specify distiller resolution (default=600)
		 -f           force existing files to be overwritten
		EOF
	exit 0
fi


# Prepare for the conversion.
answer='y'
tempfile=$( \mktemp  --suffix=".${program}.$$" )



# Make sure existing files are only overwritten if the user agrees.
if [ -e "$tempfile" ]; then
	if [ ! "$forced" = 'y' ]; then
		\echo      "$program:  Warning, the file $tempfile exists!"
		\echo  -n  "$program:  Should I overwrite it (y/n)? "
		\read  -r  answer
	fi
	if [ ! "$answer" = 'y' ]; then
		\echo  "$program:  Program terminated [ok]"
		exit  0
	fi
fi

# Loop through all files specified on the command line.
for file
do

# Get the base name of the file we are processing.
if [ "$( \dirname "$file" )" = '.' ]; then
	dir=''
else
	dir="$( \dirname "$file" )/"
fi
base=$dir$( \basename  "$file" .eps )

# See if the input file is there.
if [ ! -f "$base".eps ]; then
	\echo  "$program:  File $base.eps: no such file (skipping)" 1>&2
	continue
fi
if [ ! -r "$base".eps ]; then
	\echo  "$program:  File $base.eps: not readable (skipping)" 1>&2
	continue
fi

\echo  "$program:  Processing file $base.eps"

# See if the EPS file contains an appropriate bounding box.
if [ ! "$( \sed '/EndComments/ q' "$base".eps | grep -c %%BoundingBox )" -eq '1' ];
then
	\echo  "$program:  File $base.eps:  No bounding box found (skipping)" 1>&2
	continue
fi

answer='y'

# Only overwrite existing JPEG file if the user agrees.
if [ -e "$base.jpg" ]; then
	if [ ! "$forced" = 'y' ]; then
		\echo      "$program:  Warning, the file $base.jpg exists!"
		\echo  -n  "$program:  Should I overwrite it (y/N)?"
		\read  -r  answer
	fi
fi

# Perform the conversion or skip the file.
if [ "$answer" = 'y' ]; then
	awk 'BEGIN {header=1}
		$1 ~ /BoundingBox/ {
		  if (header==1) {
			xoff=-$2; yoff=-$3; $5=$5-$3; $4=$4-$2; $3=0; $2=0;
			print; printf "<< /PageSize [%d %d] >> setpagedevice\n",$4,$5;
			print "gsave",xoff,yoff,"translate";}
		  else {print}}
		$1 ~ /EndComments/ {header=0}
		$1 !~ /BoundingBox/ {print}
		END {print "grestore"}' "$base.eps" |
		gs  "$gsopts"  -r"$distres" -sDEVICE="jpeg${mode}" -sOutputFile="$base.jpg"\
			- -c quit 2> "$tempfile"
		if [ ! "$?" -eq 0 ]; then
			\echo  "$program:  Ghostscript reported the following errors:"
			\cat  "$tempfile"
			\echo  "$program:  $base.eps could not be converted [error]"
		else
			\echo  "$program:  $base.eps -> $base.jpg [ok]"
		fi
else
	\echo  "$program: file $base.eps skipped [ok]"
fi

done

# Clean up.
\rm  --force  "$tempfile"

#!/bin/bash
#
# The eps2jpg script converts eps files to jpeg format while respecting the
# bounding box. It invokes ghostscript for the conversion.
#
# Wouter Kager, 2004/05/23

program=`basename "$0"`
gsopts="-q -dMaxBitmap=300000000 -dSAFER -dNOPAUSE -dBATCH"
forced="n"
distres="600"
mode="gray"

echo -e "$program 2004/05/23 by Wouter Kager\n"

# Scan command line options.
while getopts "Cd:f" optionkey $*; do
	case $optionkey in
		C)	mode="" ;;
		d)	distres="$OPTARG" ;;
		f)	forced="y" ;;
		:)	echo "$program: the option -$OPTARG requires an argument!"
			echo "$program: run $program without arguments for help"
			exit 1 ;;
		?)	echo "$program: the option -$OPTARG is illegal!"
			echo "$program: run $program without arguments for help"
			exit 1 ;;
	esac
done

# Shift away the specified options.
shift $[$OPTIND-1]

# Check if we have received any input files.
if [ $# -eq 0 ]; then
	cat <<-EOF
		Usage: $program [options] file(s)
		
		The valid options are:
		 -C           color mode (default=gray)
		 -d res       specify distiller resolution (default=600)
		 -f           force existing files to be overwritten
		EOF
	exit 0
fi

# Prepare for the conversion.
temp="$program$$"
answer="y"
filelist="$temp.log"

# Make sure existing files are only overwritten if the user agrees.
if [ -e "$temp.log" ]; then
	if [ ! "$forced" = "y" ]; then
		echo "$program: warning, the file $j exists!"
		echo -n "$program: should I overwrite it (y/n)? "
		read answer
	fi
	if [ ! "$answer" = "y" ]; then
		echo "$program: program terminated [ok]"
		exit 0
	fi
fi

# Loop through all files specified on the command line.
for file
do

# Get the base name of the file we are processing.
if [ `dirname "$file"` = "." ]; then
	dir=""
else
	dir=`dirname "$file"`/
fi
base=$dir`basename "$file" .eps`

# See if the input file is there.
if [ ! -f "$base".eps ]; then
	echo -e "$program: file $base.eps: no such file (skipping)\n" 1>&2
	continue
fi
if [ ! -r "$base".eps ]; then
	echo -e "$program: file $base.eps: not readable (skipping)\n" 1>&2
	continue
fi

echo "$program: processing file $base.eps"

# See if the EPS file contains an appropriate bounding box.
if [ ! `sed '/EndComments/ q' "$base".eps | grep -c %%BoundingBox` = "1" ];
then
	echo -e "$program: file $base.eps: no bounding box found (skipping)\n" 1>&2
	continue
fi

answer="y"

# Only overwrite existing JPEG file if the user agrees.
if [ -e "$base.jpg" ]; then
	if [ ! "$forced" = "y" ]; then
		echo "$program: warning, the file $base.jpg exists!"
		echo -n "$program: should I overwrite it (y/n)? "
		read answer
	fi
fi

# Perform the conversion or skip the file.
if [ "$answer" = "y" ]; then
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
		gs $gsopts -r$distres -sDEVICE="jpeg$mode" -sOutputFile="$base.jpg"\
			- -c quit 2> "$temp.log"
		if [ ! "$?" = "0" ]; then
			echo "$program: ghostscript reported the following errors:"
			cat "$temp.log"
			echo -e "$program: $base.eps could not be converted [error]\n"
		else
			echo -e "$program: $base.eps -> $base.jpg [ok]\n"
		fi
else
	echo -e "$program: file $base.eps skipped [ok]\n"
fi

done

# Clean up.
rm -f $filelist

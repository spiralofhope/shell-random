#!/bin/sh

# Emulate `xmessage` using `Xdialog`
# Note that when the "-buttons" option is passed to this wrapper, `xmessage` is actually invoked as there is (currently) no way to emulate exactly this option with Xdialog...

# https://blog.spiralofhope.com/?p=43404
# https://web.archive.org/web/20191002140413/http://xdialog.free.fr/Xmessage.txt
# http://xdialog.free.fr/Xmessage.txt


OPTIONS="$*"
BUTTONS=''
FILE=''
TITLE='Xmessage'
WMCLASS='xmessage'
XSIZE=80
YSIZE=40
PLACEMENT='--auto-placement'
# It looks like "xmessage" does not like non-monospacing fonts and refuses
# any "-fn" option with proportional fonts as parameter. We will not have to
# worry about parsing the X "-fn" option then...
FONT='--fixed-font'
TIMEOUT=''


if !  \
  command  -v  Xdialog
then
  \echo  'ERROR:  Xdialog not found.'
  exit  1
fi


if [ -z "$*" ]; then
	echo "This is a sample wrapper allowing to emulate the \"xmessage\" utility by
using \"Xdialog\" in the closest possible way. Note that when the \"-buttons\"
option is passed to this wrapper, \"xmessage\" is actually invoked as there
is (currently) no way to emulate exactly this option with Xdialog...

usage: Xmessage [-options] [message]

where options include:
  -file filename		file to read message from, \"-\" for stdin
  -center			pop up at center of screen
  -nearmouse			pop up near the mouse cursor
  -timeout secs			exit with status 0 after \"secs\" seconds

as well as folowing X generic options (the X options not listed are ignored):
  -geometry WIDTHxHEIGHT+X0+Y0	size for Xmessage window (X0 and Y0 ignored)
  -name ressource_name		sets the ressource name for Xmessage
				(defaults to \"xmessage\")
  -title string			title for the Xmessage window
"
	exit 0
fi

# shellcheck disable=2034
#   It's in use from $*
for i in $OPTIONS; do

	case $1 in
		-file)
			shift 1
			FILE="$1"
			;;
		-center)
			PLACEMENT="--screen-center"
			;;
		-nearmouse)
			PLACEMENT="--under-mouse"
			;;
		-timeout)
			shift 1
			TIMEOUT="$1"
			;;
		-buttons|-default)
			shift 1
			BUTTONS="true"
			;;
		-print)
			BUTTONS="true"
			;;
		-geometry)
			shift 1
			YSIZE="$1"
			XSIZE=''
			;;
		-title)
			shift 1
			TITLE="$1"
			;;
		-name)
			shift 1
			WMCLASS="$1"
			;;
		-display|-bg|-background|-bd|-bordercolor|-bw|-borderwidth|-fg|-foreground|-fn|-font|-xnllanguage|-xrm)
			echo "Xmessage: '$1' option ignored." 1>&2
			shift 1
			;;
		-iconic|-rv|-reverse|+rv|-selectionTimeout|-synchronous)
			echo "Xmessage: '$1' option ignored." 1>&2
			;;
		*)
			if [ "$1" != '' ] ; then
				TEXT="$1"
			fi
			;;
	esac

	shift 1
done

# We cannot emulate the "-buttons" option, so give up and use the true "xmessage"
# if this option was specified in the command line...
if [ "$BUTTONS" = "true" ] ; then
	echo "Buttons related options (-buttons, -default, -print) not supported,"
	echo "invoking \"xmessage\" intead..." 1>&2
  if !  \
    command  -v  xmessage
  then
    \echo  'ERROR:  xmessage not found.'
    exit  1
  fi
	xmessage "$OPTIONS"
	exit $?
fi

# Now use "Xdialog"...
if [ "$TIMEOUT" != '' ] ; then
	# If a "-timeout" option was passed, then we must emulate it because
	# only infoboxes use a timeout in Xdialog and we will use here either
	# the textbox or the tailbox.
	#
	# So first start Xdialog as an asynchronous process...
	if [ "$FILE" = '' ] ; then
		echo "$TEXT" | \
		Xdialog --title "$TITLE" --wmclass "$WMCLASS" $PLACEMENT $FONT --no-cancel \
			--tailbox "-" "$YSIZE" "$XSIZE" &
	else
		Xdialog --title "$TITLE" --wmclass "$WMCLASS" $PLACEMENT $FONT --no-cancel \
			--textbox "$FILE" "$YSIZE" "$XSIZE" &
	fi
	# Get Xdialog PID and build the source for the awk command that
	# will be used to see if Xdialog is still running.
	XDIALOG_PID=$!
	SOURCE="{ if ( \$1 = $XDIALOG_PID ) print \$1 }"
	# Now, as long as the TIMEOUT is not 0, sleep for one second, check
	# for Xdialog still being there (if not then exit immediately) and
	# decrement the TIMEOUT.
  # FIXME - this needs to be reworked.  Standalone (( is not supported
	while [ "$TIMEOUT" -gt 0 ]; do
		sleep 1
		STILL_THERE=$( ps | awk --source "$SOURCE" )
		if [ "$STILL_THERE" = '' ] ; then
			exit 0
		fi
		TIMEOUT=$(( TIMEOUT - 1 ))
	done
	# Time is over !   Kill Xdialog and exit.
	kill $XDIALOG_PID 2>/dev/null
	exit 0
else
	# No timeout, just start Xdialog synchronously then...
	if [ "$FILE" = '' ] ; then
		echo "$TEXT" | \
		Xdialog --title "$TITLE" --wmclass "$WMCLASS" $PLACEMENT $FONT --no-cancel \
			--tailbox "-" "$YSIZE" "$XSIZE"
	else
		Xdialog --title "$TITLE" --wmclass "$WMCLASS" $PLACEMENT $FONT --no-cancel \
			--textbox "$FILE" "$YSIZE" "$XSIZE"
	fi
fi

exit $?

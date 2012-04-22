#!/bin/sh

# http://ubuntuforums.org/showthread.php?t=860064
# heindsight
# http://ubuntuforums.org/showpost.php?s=d12e850665a723157f04195bae3c563d&p=6782987&postcount=7

#DEBUGING:
#set -x

CONV=0
DEREF=0
FORCE=0
LNOPTS="-s -n"
SCRIPTNAME="${0##*/}"
USAGE="Usage: $SCRIPTNAME [OPTIONS] TARGET LINK
  or:  $SCRIPTNAME [OPTIONS] -c LINK

 In the first form, create a relative symbolic link LINK pointing to
 TARGET (where TARGET can be specified by an absolute path or a path
 relative to the current directory).

 In the second form, convert the symbolic link LINK to a relative
 symbolic link pointing to the same target. If LINK is already a
 relative symlink then it is left unchanged (unless the -f or -d
 options are given).

OPTIONS:
    -c      Convert a symlink to a relative symlink.
    -d      Canonicalise the path to TARGET using: readlink -m
            (see the manual for readlink).
    -f      In the first form (without -c), force creation of LINK,
            even if it already exists. In the second form (with -c), if
            LINK is already a relative symlink, the relative path from
            LINK to it's target is recomputed and the link recreated.
    -h      Show this help and exit."
FRM=""
TARGET=""

# Convert single argument into an absolute path
abspath() {
    local p tmp tmp1 tmp2;

    if [ "x${1#/}" != "x$1" ]; then
        tmp="$1/"
    else
        tmp="$PWD/$1/"
    fi

    while [ "x$tmp" != "x/" ]; do
        tmp1="${tmp#/*/}"
        tmp2="${tmp%"$tmp1"}"
        if [ "x$tmp2" = "x/../" ]; then
            p="${p:+${p%/*/}/}"
        elif [ "x$tmp2" != "x//" -a "x$tmp2" != "x/./" ]; then
            p="${p%/}$tmp2"
        fi
        tmp="/$tmp1"
    done
    if [ "x${1%/}" = "x$1" ]; then
        p="${p%/}"
    fi
    echo "${p:-/}"
}

# Compute longest common prefix of two paths
common_prefix() {
    local pre1 pre2 p1 p2 tmp;

    pre1=""
    pre2=""
    p1="$1"
    p2="$2"

    while [ "x$pre1" = "x$pre2" -a -n "$p1" -a -n "$p2" ]; do
        tmp="${p1#*/}"
        pre1="$pre1${p1%"$tmp"}"
        p1="$tmp"

        tmp="${p2#*/}"
        pre2="$pre2${p2%"$tmp"}"
        p2="$tmp"
    done
    if [ "x$pre1" != "x$pre2" ]; then
        pre1="${pre1%/*/}"
    fi
    if [ "x${pre1%/}" = "x$pre1" ]; then
        pre1="$pre1/"
    fi
    echo ${pre1:-/}
}

# Construct a relative path from $2 to $1
make_relpath() {
    local b1 p1 p2 tmp prefix

    tmp=$(abspath "$1")
    p1="${tmp%/*}/"
    b1="${tmp#"$p1"}"

    tmp=$(abspath "$2")
    if [ "x${tmp%/}" != "x$tmp" ]; then
        p2="${tmp%/*}/"
    else
        p2="$tmp"
    fi

    prefix=$(common_prefix "$p1" "$p2")
    p1="${p1#"$prefix"}"
    p2="${p2#"$prefix"}"

    while [ "x$p2" != "x${p2#*/}" ]; do
        p2="${p2#*/}"
        p1="../$p1"
    done
    echo $p1$b1
}

# Parse command line options
while getopts "cdfh" o; do
    case $o in
        "c") CONV=1;;
        "d") DEREF=1;;
        "f") FORCE=1;;
        "h") echo "$USAGE"; exit 0;;
        \?) echo >&2 "$USAGE"; exit 1;;
    esac
done

shift $(expr $OPTIND - 1)

# Check number of arguments remaining after option parsing
if [ $CONV -eq 0 -a $# -ne 2 -o $CONV -eq 1 -a $# -ne 1 ]; then
    echo >&2 "$USAGE"
    exit 1
fi

# Convert a symlink to a relative symlink
if [ $CONV -eq 1 ]; then
    if [ ! -h "$1" ]; then
        echo >&2 $1 is not a symbolic link
        exit 1;
    fi

    FRM="$1"
    TARGET=$(readlink "$FRM")
    LNOPTS="-f $LNOPTS"

    # Check if $FRM is already relative
    if [ "x${TARGET#/}" = "x$TARGET" ]; then
        if [ $FORCE -eq 1 -o $DEREF -eq 1 ]; then
            FRMB="${FRM##*/}"
            FRMD="${FRM%"$FRMB"}"
            TARGET="${FRMD:-.}/$TARGET"
        else
            echo >&2 "$FRM is already a relative symbolic link"
            exit 1;
        fi
    fi
else
    TARGET="$1"
    FRM="$2"

    # Force creation of link even if it exists
    if [ $FORCE -eq 1 ]; then
        LNOPTS="-f $LNOPTS"
    fi
fi

# Canonicalise TARGET
if [ $DEREF -eq 1 ]; then
    TARGET=$(readlink -vm "$TARGET")
    if [ $? -ne 0 ]; then
        exit 1;
    fi
fi

if [ -d "$TARGET" ]; then
    TARGET="$TARGET/"
fi

if [ -d "$FRM" ]; then
    FRM="FRM/"
fi

# phorminx suggested this:
#if [ -d "$FRM" -a "x${FRM%/}" = "x$FRM" ]; then
  #FRM="$FRM/"
#fi

TARGET=$(make_relpath "$TARGET" "$FRM")

# Create the link
ln $LNOPTS "$TARGET" "$FRM"

: <<ENDNOTES
porg said:


Bug 1: relative.sh failed when applied on directories, as noted by @nikobonnieure. Thanks!

For those who didn't understand @nikobonnieure's sentence "Thanks to remove it and to make the end of the script file looks like" a short clarification here:

This script is a frontend to "ln. The "ln" argument "target_dir" must not have a trailing slash.
For me it worked to simply erase the whole block:

  if [ -d "$FRM" ]; then
      FRM="FRM/"
  fi

Bug 2: If your absolute symlinks have more than one consecutive space character in their filename, relative.sh creates false relative symlinks, as it normalizes all those whitespace to one-space-only.

The bug must be within the function make_relpath(). I was just nor able to track it down, as I am not really familiar with bash scripting.

Could someone please isolate the bug? Thanks!
ENDNOTES

# -----------------------------
until [ "sky" = "falling" ]; do
# -----------------------------

# NOTE: This won't work on internals like 'setopt' !!
command_test() {
#   if [ ${#@} -ne 2 ] || [[ ! "$1" =~ [0-1] ]] || [[ ! "$2" =~ [0-1] ]]; then echo "I'm expecting 2 parameters, both with either 0 or 1"; fi
  # FIXME: I don't remember how to do the equivalent of ${@[2,-1]} anymore..
  $2 $3 $4 $5 $6 $7 $8 $9 ${10}
  if [ $? -eq $1 ]; then
    echo "test passed"
  else
    echo "test failed:  wanted $2 but got $1"
  fi
}
# test 0 ls -al

# TODO: Export the command-to-array functionality into its own re-usable function.
# TODO: Count the number of matches?
# TODO: If I'm in zsh, I can stop using 'tr' and just use zsh like so:
# a=ls;b=`$a`;echo ${b[(w)-1]}
command_search() {
  # TODO: Check parameters
  command_search_COMMAND=$1
  command_search_SEARCH=$2
  ARRAY=`$command_search_COMMAND | \tr '\n' ' '`
# \echo $ARRAY
  for element in ${ARRAY[@]} ; do
#     \echo "$element"
    if [[ "$element" =~ $command_search_SEARCH ]]; then return 0 ; fi
  done
  return 1
}
command_search_test_suite() {
  \cd "/tmp"
  \echo>command_search_test_suite_file
  test 0 command_search \ls command_search_test_suite_file
  test 1 command_search \ls command_search_test_suite_nonexistant
  \rm command_search_test_suite_file
}
# command_search_test_suite

setopt_search() {
  # TODO: Check parameters
  command_search_SEARCH=$1
  a=`setopt`
#   ARRAY=$( $SHELL setopt | \tr '\n' ' ' )
# \echo $ARRAY
  for element in ${ARRAY[@]} ; do
#     \echo "$element"
    if [[ "$element" =~ $command_search_SEARCH ]]; then return 0 ; fi
  done
  return 1
}
# setopt
# setopt|grep autocdDesktop
setopt_search_test_suite() {
#   echo ""
#   echo ""
#   echo "  + proper tests:"
  test 0 setopt_search autocdDesktop
  test 1 setopt_search autocdDesktop
  test 1 setopt_search xtrace

#   test 0 unsetopt zle
#   test 1 setopt zle
#   echo "  + expecting failures:"
#   test 1 setopt failtest
#   test 1 unsetopt failtest
# Special case: This isn't actually settable..
#   test 0 setopt shinstdin
}
# setopt_search_test_suite

zsh_setopt_memory() {
  # TODO: Check parameters.  2 parameters:  $1 is a string, and $2 exists.
  if [ "$2" = "remember" ]; then
    command_search "setopt" "$1" ; a=$?
    if [ $a -eq 0 ]; then
      zsh_setopt_memory_SETOPT="set"
    elif [ $a -eq 1 ]; then
      zsh_setopt_memory_SETOPT="unset"
    else
      \echo "command_search 'setopt' $1 returned a code of $a and I don't know what to do with that."
    fi
  elif [ "$2" = "restore" ]; then
    if [ $zsh_setopt_memory_SETOPT="set" ]; then
      \setopt "$1"
    elif [ $zsh_setopt_memory_SETOPT="unset" ]; then
      \unsetopt "$1"
    else
      \echo "error with the variable \$zsh_setopt_memory_SETOPT, expecting 'set' or 'unset' and I got:  $zsh_setopt_memory_SETOPT"
    fi
#     zsh_setopt_memory_SETOPT=""
  else
    echo "\$2 should be either 'remember' or 'restore'"
    return 255
  fi
echo $zsh_setopt_memory_SETOPT
}
zsh_setopt_memory_test() {
  # Setup
  \unsetopt xtrace
  # Test - remember
  zsh_setopt_memory "xtrace" "remember"
  echo "remember says:  $zsh_setopt_memory_SETOPT"
  # Test - fiddling
  \setopt xtrace
  # Test - restore
  zsh_setopt_memory "xtrace" "restore"
  echo "restore says:  $zsh_setopt_memory_SETOPT"
  # Results
  \unsetopt|grep "xtrace"
  if [ $? -eq "0" ]; then
    echo "test passed"
  else
    echo "test failed"
  fi
  # Teardown
  \unsetopt xtrace
}
# zsh_setopt_memory_test


#--------------------------------------------------------------------
break
done
#--------------------------------------------------------------------
: <<HERE_DOCUMENT



# TODO: Check for $1 and parameter sanity
# TODO: Check if I've been passed an ISO (*.iso)
"mount-root" -o loop ~/test.iso /mnt/mnt


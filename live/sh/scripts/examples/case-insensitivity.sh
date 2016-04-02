#!/usr/bin/env  sh

# Demonstrate case-sensitive and -insensitive settings.
# .. both for programs and for a "for loop".



command() {
  # ls  -1  $tmp/
  for i in $tmp/*; do
    \echo  $i
  done
}


setup() {
  tmp=/tmp/conditionals.$$
  \mkdir  $tmp/
  \mkdir  $tmp/aaa
  \mkdir  $tmp/AAA
  \mkdir  $tmp/bbb
  \mkdir  $tmp/BBB
  \mkdir  $tmp/ccc
  \mkdir  $tmp/CCC
}


go() {


  \echo
  \echo  '-- before'
  command

  \echo
  \echo  '-- case-insensitive'
  LC_COLLATE=en_US ; export LC_COLLATE
  command
  # =>
  #aaa
  #AAA
  #bbb
  #BBB
  #ccc
  #CCC

  \echo
  \echo  '-- case-sensitive'
  LC_COLLATE=C ; export LC_COLLATE
  command
  # =>
  #AAA
  #BBB
  #CCC
  #aaa
  #bbb
  #ccc
}


teardown() {
  \rmdir  $tmp/*
  \rmdir  $tmp/
}



setup
go
teardown

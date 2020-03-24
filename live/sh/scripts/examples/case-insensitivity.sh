#!/usr/bin/env  sh

# Demonstrate case-sensitive and -insensitive settings.
# .. both for programs and for a "for loop".

# This no longer works as of
# 2020-03-23 - Debian 10.1.0-amd64-xfce-CD-1


working_directory=$( \mktemp  --directory )


command() {
  #ls  -1  "$working_directory"/
  for i in "$working_directory"/*; do
    \echo  "$i"
  done
}


setup() {
  \mkdir  "$working_directory"/aaa
  \mkdir  "$working_directory"/AAA
  \mkdir  "$working_directory"/bbb
  \mkdir  "$working_directory"/BBB
  \mkdir  "$working_directory"/ccc
  \mkdir  "$working_directory"/CCC
}


go() {
  \echo  ''
  \echo  '-- before'
  command

  \echo  ''
  \echo  '-- case-insensitive'
  # This used to work
  LC_COLLATE=en_US ; export LC_COLLATE
  # This does not work either:
  #LC_COLLATE=en_US.utf8 ; export LC_COLLATE
  command
  # =>
  #aaa
  #AAA
  #bbb
  #BBB
  #ccc
  #CCC

  \echo  ''
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
  \rmdir  "$working_directory"/*
  \rmdir  "$working_directory"
}



setup
go
teardown

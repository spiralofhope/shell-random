#!/usr/bin/env  sh
:<<'}'   #  Other shells
{
#!/usr/bin/env  bash
#!/usr/bin/env  zsh
#!/usr/bin/env  boo
}
# https://blog.spiralofhope.com/?p=598



#:<<'}'   #  Directly
{
  \basename  "$( \readlink  --canonicalize /proc/$$/exe )"
  # =>
  # dash
}


#:<<'}'   #  Using `ps`'
{
  \ps  -o cmd  --no-heading $$  |\
    \cut --delimiter=' ' --fields=1
  # =>
  # sh
}



#:<<'}'   #  Using builtins
{
  if  !  \
    help  >  /dev/null 2>&1
  then
    \echo  'bash?'
  else
    \echo  'not bash?'
  fi
}

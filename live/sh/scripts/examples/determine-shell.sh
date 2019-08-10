#!/usr/bin/env  sh
:<<'}'   #  Other shells
{
#!/usr/bin/env  bash
#!/usr/bin/env  zsh
#!/usr/bin/env  boo
}
# https://blog.spiralofhope.com/?p=598



\echo  ' * Directly'
\basename  $( \readlink  --canonicalize /proc/$$/exe )

\echo
\echo  ' * Using `ps`'
\echo  $( \ps  -o cmd  --no-heading $$ | \cut --delimiter=' ' --fields=1 )

\echo
\echo  ' * Checking for builtins'
#help >/dev/null 2>&1 || \echo  'not bash?'
help >/dev/null 2>&1
if [ $? -eq 0 ]; then
  \echo  'bash?'
else
  \echo  'not bash?'
fi

Newly-run applications will deposit new configuration files which are 
mixed with existing configuration files from preferred applications.

There is no consistency between the name of a program and the name of 
its configuration directory/file(s).

Installing a Linux distribution will destroy existing configuration 
files when it overwrites  `/home` -- if  `/home`  is not kept on a 
separate partition (or equivalent).


To solve these problems, I identified the configuration directory/file 
for each application whose configuration I want to survive a 
re-install.  I keep that content away from /home and use symlinks.

This scripting was created to make it trivial to re-create those 
symlinks after re-installing.


Example:

If git's configuration is stored in the file  `~/.gitconfig`

I can move it into this directory structure.

```bash
  \mv  ~/.gitconfig  ./home-user--dotfiles/gitconfig
```

Note that I've renamed it from  `.gitconfig`  to just  `gitconfig`  
with no preceding period.  This makes life a little easier when 
browsing through these directory structures.  I was also afraid that on 
some bad day I may see an "empty" directory and just delete it.

Then I can run the script and have this equivalent done automatically:

```bash
  \ln  --symbolic  ./home-user--dotfiles/gitconfig  ~/.gitconfig
```

Having dozens of applications "backed up" like this becomes very easy 
to restore after re-installing.

I can also nuke  `/home`  and get rid of the configuration for any 
software which I tried but never kept.

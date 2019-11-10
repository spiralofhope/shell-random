- Programs create user preference information in `$HOME`.
- The name of the files may not be easily mapped to the name of the program.
- Files within `$HOME` might be overwritten by a new distribution's install.
- Maintaining a separate partition for `$HOME` is annoying.
- Testing new software may deposit more content in `$HOME`.

Sooner or later `$HOME` will be completely cluttered and confused.

----

To solve these problems, I manually identify the configuration directory/file for each application whose configuration I want to survive a re-install.  I move those data away from `$HOME` and instead use symlinks to them.

This scripting was created to make it trivial to re-create those symlinks after re-installing.


Example:

If git's configuration is stored in the file  `~/.gitconfig`

I can move it into this directory structure.

```bash
  target='/path/to/home-user--dotfiles/'
  \mkdir             $target/
  \mv  ~/.gitconfig  $target/
```

Then I can run this script and have this action done automatically:

```bash
  \ln  --symbolic  ./home-user--dotfiles/.gitconfig  ~/
```

(Target collisions are renamed.)

It becomes very easy to restore configuration data "backed up" like this.

I can also nuke all of `$HOME`, as with a distribution reinstall, to remove the configuration for any software which I tried but never kept.

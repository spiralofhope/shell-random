# Used by dash (sh)



# It really isn't quite right to leverage the existence of ~/.zshrc like this, but it works for my setup.
if [ $( \whoami ) = 'root' ]; then
      shdir="$( \realpath $( \dirname $( \realpath  /home/user/.zshrc ) )/../../sh/ )"
else  shdir="$( \realpath $( \dirname $( \realpath  ~/.zshrc          ) )/../../sh/ )"
fi

{  # 'source' additional scripting and settings.

  sourceallthat() {
    #\echo  "sourcing $1"
    \cd  "$1"
    if [ -f 'lib.sh' ]; then
      .  './lib.sh'
    fi
    for i in *.sh; do
      if [ "$i" = 'lib.sh' ]; then
        continue
      fi
      .  "./$i"
    done
    unset  i
  }

  sourceallthat  "$shdir/"

  \unset  -f  sourceallthat

}

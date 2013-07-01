# FIXME - must not be run as root

date=$( \date +%Y-%m-%d--%H-%M-%S )
\echo  ""
\echo  " * Preparing home/user/ dot files.."
for i in *; do
  if [ ! -f $i ]; then
    continue
  fi
  # Back up any existing files.
  # If a file and not a symlink.
  if [ -f ~/.$i -a ! -L ~/.$i ]; then
    \mv  ~/.$i  ~/.${i}--$date
  fi
  \ln  --force  --no-target-directory  --symbolic  $PWD/$i  ~/.$i
done


\echo  ""
\echo  " * Preparing home/user/ dot directories.."
for i in *; do
  if [ ! -d $i ]; then
    continue
  fi
  # Back up any existing directories.
  # If a directory and not a symlink.
  if [ -d ~/.$i -a ! -L ~/.$i ]; then
    \mv  ~/.$i  ~/.${i}--$date
  fi
  \ln  --force  --no-target-directory  --symbolic  $PWD/$i  ~/.$i
done


\echo  " .. done. "

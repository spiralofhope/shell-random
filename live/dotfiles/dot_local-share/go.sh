# FIXME - must not be run as root
# FIXME - this is blind right now, but I ought to be selective..

date=$( \date +%Y-%m-%d--%H-%M-%S )
\echo ""
\echo " * Preparing home/user/ dot files and directories.."
\mkdir  --parents  ~/.local/

# Back up any existing directories.
# If a directory and not a symlink.
if [ -d ~/.local/share -a ! -L ~/.local/share ]; then
  \mv  ~/.local/share  ~/.local/share--$date
fi
# Since I can't seem to properly force the overwrite.. try this.
if [ -L ~/.local/share ]; then
  \rm  --force  ~/.local/share
fi
\ln  --force  --no-target-directory  --symbolic  $PWD  ~/.local/share

\echo " .. done. "

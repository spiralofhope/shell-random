#!/usr/bin/env  sh
# Search-replace an editor's name and email address.
# https://help.github.com/en/github/using-git/changing-author-info



if [ -z "$3" ]; then
  \echo  '[email] [email] [user]
Rewrite the commit log author information.

example of use:
'"$( \basename  "$0" )"'  search@example.com  replace@example.com  username
'
  exit
fi


# \git  clone  --bare https://github.com/user/repo.git
# cd  repo.git


\git  filter-branch  --env-filter '
search_email="$1"
replace_email="$2"
replace_name="$3"

if [ "$GIT_COMMITTER_EMAIL" = "$search_email" ]; then
    export  GIT_COMMITTER_NAME="$replace_name"
    export  GIT_COMMITTER_EMAIL="$replace_email"
fi
if [ "$GIT_AUTHOR_EMAIL" = "$search_email" ]; then
    export  GIT_AUTHOR_NAME="$replace_name"
    export  GIT_AUTHOR_EMAIL="$replace_email"
fi
# -f is force the overwrite of any backup
'  --force  --tag-name-filter  cat  --  --branches  --tags


# \git  push  --force  --tags origin 'refs/heads/*'
# \cd ..
# \rm  --recursive  --force  ./repo.git

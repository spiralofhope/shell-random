#!/usr/bin/env  sh
# Search-replace an editor's name and email address.
# TODO - this can be made more fancy by accepting user input so it doesn't have to be edited directly.
# https://help.github.com/en/github/using-git/changing-author-info



# \git  clone  --bare https://github.com/user/repo.git
# cd  repo.git


\git  filter-branch  --env-filter '
email_search="search@example.com"
email_replace="replace@example.com"
name_replace="user"

if [ "$GIT_COMMITTER_EMAIL" = "$email_search" ]; then
    export  GIT_COMMITTER_NAME="$name_replace"
    export  GIT_COMMITTER_EMAIL="$email_replace"
fi
if [ "$GIT_AUTHOR_EMAIL" = "$email_search" ]; then
    export  GIT_AUTHOR_NAME="$name_replace"
    export  GIT_AUTHOR_EMAIL="$email_replace"
fi
# -f is force the overwrite of any backup
'  --force  --tag-name-filter  cat  --  --branches  --tags


# \git  push  --force  --tags origin 'refs/heads/*'
# \cd ..
# \rm  --recursive  --force  ./repo.git

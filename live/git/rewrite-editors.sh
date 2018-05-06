#!/usr/bin/env  sh
# Search-replace an editor's name and email address.
  #  Note that you may have to nuke and re-create your remote repository.  I don't know.
# At least as old as 2017-10-20



\git  filter-branch  --env-filter '
WRONG_EMAIL="wrong@example.com"
NEW_NAME="Some Name"
NEW_EMAIL="author@example.com"

if [ "$GIT_COMMITTER_EMAIL" = "$WRONG_EMAIL" ]
then
    export GIT_COMMITTER_NAME="$NEW_NAME"
    export GIT_COMMITTER_EMAIL="$NEW_EMAIL"
fi
if [ "$GIT_AUTHOR_EMAIL" = "$WRONG_EMAIL" ]
then
    export GIT_AUTHOR_NAME="$NEW_NAME"
    export GIT_AUTHOR_EMAIL="$NEW_EMAIL"
fi
# -f is force the overwrite of any backup
' -f --tag-name-filter cat -- --branches --tags

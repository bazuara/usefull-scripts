#!/bin/sh
## Reset all commits user and email to correct ones
## Dont forget to run 
## git push --force --tags origin 'refs/heads/*' 
## after checking everything is ok in gitlog
git filter-branch -f --env-filter '
CORRECT_NAME="Bruno Azuara"
CORRECT_EMAIL="bruno.azuara@gmail.com"
if [ "$GIT_COMMITTER_EMAIL" ]
then
    export GIT_COMMITTER_NAME="$CORRECT_NAME"
    export GIT_COMMITTER_EMAIL="$CORRECT_EMAIL"
fi
if [ "$GIT_AUTHOR_EMAIL" ]
then
    export GIT_AUTHOR_NAME="$CORRECT_NAME"
    export GIT_AUTHOR_EMAIL="$CORRECT_EMAIL"
fi
' --tag-name-filter cat -- --branches --tags
echo "No olvides git push --force --tags origin 'refs/heads/*' despues de comprobar todo en git log"
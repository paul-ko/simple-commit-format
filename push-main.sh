#!/usr/bin/env bash

here=$(dirname "$0")

# shellcheck disable=SC1090
. "$here/push-commit-format.sh"

failures=0
local_sha="$PRE_COMMIT_TO_REF"
remote_sha="PRE_COMMIT_FROM_REF"
for commit_sha in $(git rev-list "$remote_sha".."$local_sha"); do
    msg=$(git show --format=%B "$commit_sha")
    failures=$(( failures + $(validate_commit_message_format "$msg" "$commit_sha") ))
done
exit $failures

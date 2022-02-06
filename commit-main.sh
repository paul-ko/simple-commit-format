#!/usr/bin/env bash

here=$(dirname "$0")

# shellcheck disable=SC1090
. "$here/commit-validate.sh"
return $(validate_commit_msg_file "$1")

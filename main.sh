#!/usr/bin/env bash

here=$(dirname "$0")

# shellcheck disable=SC1090
. "$here/simple-commit-format.sh"

ret_val=$(validate_commit_msg_file "$1")
if [[ $ret_val -ne 0 ]]; then
    exit 1
fi

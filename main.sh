#!/usr/bin/env bash

# shellcheck disable=SC1091
. ./simple-commit-format.sh

ret_val=$(validate_commit_msg_file "$1")
if [[ $ret_val -ne 0 ]]; then
    exit 1
fi

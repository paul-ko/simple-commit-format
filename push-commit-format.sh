#!/usr/bin/env bash

#remote="$1"
#url="$2"

# shellcheck disable=SC1091
. ./simple-commit-format.sh


print_failure() {
    commit_sha="$1"
    error="$2"
    if ! tput 2>/dev/null; then
        red=$(tput setaf 1)
        normal=$(tput sgr0)
    else
        red=""
        normal=""
    fi
    printf "%sFAIL%s: %s - %s\n" "$red" "$normal" "$commit_sha" "$error" 1>&2
}


validate_commit_message_format() {
    message="$1"
    commit_sha="$2"
    line_no=1  # 1-based for user-facing messages.
    failed=0
    while IFS= read -r line; do
        # First line validation fails on
        # * More than 50 characters
        # * Fewer than 2 words
        # * Ends with a period
        # First line validation warns on
        # * Doesn't start with a capital letter
        if [[ $line_no -eq 1 ]]; then
            if echo "$line" | grep -q '.*\.$'; then
                print_failure "$commit_sha" "Line $line_no ends with a period."
                failed=1
            fi
            if [[ ${#line} -gt 50 ]]; then
                print_failure "$commit_sha" "Line $line_no exceeds 50 characters."
                failed=1
            fi
            word_count=$(echo "$line" | wc -w)
            if [[ $word_count -lt 2 ]]; then
                print_failure "$commit_sha" "Line $line_no does not contain at least 2 words."
                failed=1
            fi

        # Second line validation fails on
        # * More than 0 characters
        elif [[ $line_no -eq 2 ]] ; then
            if [[ ${#line} -gt 0 ]]; then
                print_failure "$commit_sha" "Line $line_no is not empty."
                failed=1
            fi

        # Subsequent line validations fails on
        # * More than 72 characters
        else
            if [[ ${#line} -gt 72 ]]; then
                print_failure "$commit_sha" "Line $line_no exceeds 72 characters."
                failed=1
            fi
        fi
        line_no=$(( line_no + 1 ))
    done <<< "$message"
    echo "$failed"
}

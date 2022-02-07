#!/usr/bin/env bash

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


validate_1st_line() {
    line="$1"
    commit_sha="$2"
    failed=0
    char_count=$(printf "$line" | wc -m)
    if echo "$line" | grep -q '.*\.$'; then
        print_failure "$commit_sha" "Line $line_no ends with a period."
        failed=1
    fi
    if [[ $char_count -gt 50 ]]; then
        print_failure "$commit_sha" "Line $line_no exceeds 50 characters."
        failed=1
    fi
    word_count=$(echo "$line" | wc -w)
    if [[ $word_count -lt 2 ]]; then
        print_failure "$commit_sha" "Line $line_no does not contain at least 2 words."
        failed=1
    fi
    printf "$failed"
}


validate_2nd_line() {
    line="$1"
    commit_sha="$2"
    if [[ ${#line} -gt 0 ]]; then
        print_failure "$commit_sha" "Line 2 is not empty."
        printf "1"
    else
        printf "0"
    fi

}


validate_body_line() {
    line="$1"
    commit_sha="$2"
    line_no="$3"
    char_count=$(printf "$line" | wc -m)
    if [[ $char_count -gt 72 ]]; then
        print_failure "$commit_sha" "Line $line_no exceeds 72 characters."
        printf "1"
    else
        printf "0"
    fi
}


validate_commit_message_format() {
    message="$1"
    commit_sha="$2"
    printf "> %s\n" "$commit_sha" 1>&2
    line_no=0
    while IFS= read -r line; do
        line_no=$(( line_no + 1 ))  # 1-based for user messages.
        # Trim carriage returns for accurate character counts.
        line=$(echo "$line" | tr -d "\r")

        # First line validation fails on
        # * More than 50 characters
        # * Fewer than 2 words
        # * Ends with a period
        if [[ $line_no -eq 1 ]]; then
            failed=$(validate_1st_line "$line" "$commit_sha")

        # Second line validation fails on
        # * More than 0 characters
        elif [[ $line_no -eq 2 ]] ; then
            new_failed=$(validate_2nd_line "$line" "$commit_sha")
            failed=$(( new_failed + failed ))

        # Subsequent line validations fails on
        # * More than 72 characters
        else
            new_failed=$(validate_body_line "$line" "$commit_sha" "$line_no")
            failed=$(( new_failed + failed ))
        fi
    done <<< "$message"
    if [[ $failed -eq 0 ]]; then
        printf "0"
    else
        printf "1"
    fi
}

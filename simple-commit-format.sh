#!/usr/bin/env bash

validate_commit_msg_file() {
    line_no=1  # 1-based for user-facing messages.
    warned=0
    failed=0
    while IFS= read -r line
    do
        # Ignore lines that start with #.
        # If you use an editor instead of -m, such lines are automatically created
        # but not actually included the generated commit message.
        if echo "$line" | grep -q "^#"; then
            continue
        fi
        # First line validation fails on
        # * More than 50 characters
        # * Fewer than 2 words
        # * Ends with a period
        # First line validation warns on
        # * Doesn't start with a capital letter
        if [[ $line_no -eq 1 ]]; then
            if echo "$line" | grep -q '.*\.$'; then
                printf "FAIL: Line %d ends with a period.\n" $line_no 1>&2
                failed=1
            fi
            if [[ ${#line} -gt 50 ]]; then
                printf "FAIL: Line %d exceeds 50 characters!\n" $line_no 1>&2
                failed=1
            fi
            word_count=$(echo "$line" | wc -w)
            if [[ $word_count -lt 2 ]]; then
                printf "FAIL: Line %d does not contain at least 2 words.\n" $line_no 1>&2
                failed=1
            fi
            if ! echo "$line" | grep -q "^[A-Z]"; then
                printf "WARN: Line %d doesn't start with a capital letter.\n" $line_no 1>&2
                warned=1
            fi

        # Second line validation fails on
        # * More than 0 characters
        elif [[ $line_no -eq 2 ]] ; then
            if [[ ${#line} -gt 0 ]]; then
                printf "FAIL: Line %d is not empty!\n" $line_no 1>&2
                failed=1
            fi

        # Subsequent line validations fails on
        # * More than 72 characters
        else
            if [[ ${#line} -gt 72 ]]; then
                printf "FAIL: Line %d exceeds 72 characters!\n" $line_no 1>&2
                failed=1
            fi
        fi
        line_no=$(( line_no + 1 ))
    done < "$1"

    # Overall validation warns if
    # * Fewer than 3 lines
    if [[ $line_no -lt 3 ]]; then
        printf "WARN: No details provided in commit message.\n" 1>&2
        warned=1
    fi
    if [[ $failed -ne 0 ]]; then
        full_msg=$(cat "$1")
        printf "Commit message rejected due to validation failures. Original message:\n\n%s\n\n" "$full_msg" 1>&2
    elif [[ $warned -ne 0 ]]; then
        printf "Consider amending.\n" 1>&2
    fi
    echo "$failed"
}

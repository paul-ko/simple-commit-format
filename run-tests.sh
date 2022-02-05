#!/usr/bin/env bash

# shellcheck disable=SC1091
. ./simple-commit-format.sh

declare -a _test_failures

_print_header() {
    main="| $1 |"
    surround=$(echo "$main" | tr "[:print:]" "-")
    printf -- "\n%s\n%s\n%s\n" "$surround" "$main" "$surround"
}

# We won't use funky filenames, so we can skip the find -print 0 | xargs -0
# approach to directory iteration.
_print_header "Testing should-fail messages"
for f in test/fail*.txt; do
    printf "\n> Running %s\n" "$f"
    ret_val=$(validate_commit_msg_file "$f")
    echo "> exit code: $ret_val"
    if [[ $ret_val -eq 0 ]]; then
        printf "> !!!!! DID NOT FAIL !!!!!\n"
        _test_failures+=("$f did not fail validation")
    fi
done

_print_header "Testing should-warn messages"
for f in test/warn*.txt; do
    printf "\n> Running %s\n" "$f"
    ret_val=$(validate_commit_msg_file "$f")
    echo "> exit code: $ret_val"
    if [[ $ret_val -ne 0 ]]; then
        printf "> !!!!! DID NOT PASS !!!!!\n"
        _test_failures+=("$f did not pass validation")
    fi
done

_print_header "Testing should-pass messages"
for f in test/pass*.txt; do
    printf "\n> Running %s\n" "$f"
    ret_val=$(validate_commit_msg_file "$f")
    echo "> exit code: $ret_val"
    if [[ $ret_val -ne 0 ]]; then
        printf "> !!!!! DID NOT PASS !!!!!\n"
        _test_failures+=("$f did not pass validation")
    fi
done

if [[ ${#_test_failures} -gt 0 ]]; then
    _print_header "TEST FAILURES"
    for failure in "${_test_failures[@]}"; do
        printf "* %s\n" "$failure"
    done
fi

printf "Don't forget to check output, especially for warn cases.\n"


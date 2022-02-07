#!/usr/bin/env bash

# shellcheck disable=SC1091
. ./push-validate.sh

declare -a _test_failures
_green=$(tput setaf 2)
_magenta=$(tput setaf 5)
_normal=$(tput sgr0)

_print_header() {
    main="| $1 |"
    surround=$(echo "$main" | tr "[:print:]" "-")
    printf -- "\n%s\n%s\n%s\n" "$surround" "$main" "$surround"
}

run_test() {
    should="should $1"
    file_glob="test/$1*.txt"
    if [[ $1 == "fail" ]]; then
        expected_exit_code=1
    else
        expected_exit_code=0
    fi
    _print_header "Test $should messages"
    # We don't have odd characters in our test filenames, so we can
    # use a simple for-loop instead find -print 0 | xargs -0 fun.
    for f in $file_glob; do
        message=$(cat $f)
        printf "\n%s> Running %s%s\n" "$_green" "$f" "$_normal"
        ret_val=$(validate_commit_message_format "$message" "$dummy_sha")
        if [[ $ret_val -ne $expected_exit_code ]]; then
            msg="Got unexpected status code $ret_val on ${f}"
            printf "%s\n" "$msg"
            _test_failures+=("$msg")
        else
            printf "Got expected status code %s\n" "$ret_val"
        fi
    done
}

for val in fail pass; do
    run_test "$val"
done

if [[ ${#_test_failures} -gt 0 ]]; then
    _print_header "TEST FAILURES"
    for failure in "${_test_failures[@]}"; do
        printf "* %s%s%s\n" "$_magenta" "$failure" "$_normal"
    done
fi

printf "\nDon't forget to check output, especially for warn cases.\n"

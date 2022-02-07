# simple-commit-message-format
A simple git pre-push hook that validates the commit message's format.
Install using [pre-commit](https://pre-commit.com/).

## Validations
The first line of any commit message with fail validation if

* it contains more than 50 characters
* it does not contain at least 2 words
* it ends with a period

The second line of any commit message with fail validation if

* it contains any characters

The third and subsequent lines of any commit message will fail validation if

* it contains more than 72 characters

Single-line commit messages are valid as long as the first line passes validation.

## Inspiration
The validation rules are based on longstanding best practices.
[This article](https://cbea.ms/git-commit/) explores some of the thinking behind them.

## pre-commit support
Add this to your .pre-commit-commit.yaml:
```
  - repo: https://github.com/paul-ko/simple-commit-message-format
    rev: "v1.1.1"
    hooks:
      - id: check-msg-format-on-push
        stages: [push]
```

Install using `pre-commit install --hook-type pre-push`

## Alternatives
[Commitizen](https://github.com/commitizen-tools/commitizen/) provides a rich feature
set to validating commit messages.

# simple-commit-message-format
A simple git commit-msg hook that validates the commit message's format.
It can be executed as commit-msg hook, executed against an individual hook, or as a
pre-push hook, executed against all commits that are being pushed.
It can installed using pre-commit.
The hooks are implemented as shell scripts, to support being installed as or called from
traditional git hooks.

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

### Pre-push
Add this to your .pre-commit-commit.yaml:
```
  - repo: https://github.com/paul-ko/simple-commit-message-format
    rev: "v1.1.1"
    hooks:
      - id: check-msg-format-on-push
        stages: [push]
```

Install using `pre-commit install --hook-type pre-push`


### Pre-commit
Add this to your .pre-commit-commit.yaml:
```
  - repo: https://github.com/paul-ko/simple-commit-message-format
    rev: "v1.1.1"
    hooks:
      - id: check-msg-format-on-commit
        stages: [commit-msg]
```

Install using `pre-commit install --hook-type commit-msg`

## Alternatives
[Commitizen](https://github.com/commitizen-tools/commitizen/) provides a richer feature
set based on a different approach to commit messages.


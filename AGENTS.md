# Curtis's AI Assistant Guide

## Environment

- Shell: zsh + oh-my-zsh, vi-mode
- Dotfiles: `~/code/ctrueden/dotfiles`
- Projects: `~/code/<org>/<repo>` cloned from `git@github.com:<org>/<repo>`

## Environment variables

Before adding or moving an exported variable, read `$DOTFILES/docs/environment.md`:
which file it goes in depends on which contexts need it.

## Sub-rules

Read the relevant file(s) before working in that domain:

- `$DOTFILES/rules/python.md` — uv tooling, pytest, pyproject.toml conventions
- `$DOTFILES/rules/java.md` — Maven, SciJava BOM, JUnit, CI patterns
- `$DOTFILES/rules/git.md` branch naming, commit style, rebase/merge workflow

## Language Hints

**Python**: In uv-managed projects (those with `pyproject.toml`/`uv.lock`), run
project code, tests and tools via `uv` — `uv run python` (not `python3`),
`uv add` (not `pip install`), `uv sync` to install deps — never bare `python3`
or `pip`, which miss the project's environment. Throwaway one-off snippets
unrelated to any project (parsing output, data munging) may use `python3`.

**Java**: Maven-based, typically extending `org.scijava:pom-scijava` parent POM.
Maintained orgs: scijava, imglib, scifio, apposed, imagej, fiji, trackmate, trakem2.

**Kotlin**: Maven for standard projects; Gradle only for KMP/Native (e.g., appose/jaunch).

**Shell**: POSIX-compatible `.sh` unless zsh-specific (`.zsh`) or bash-specific (`.bash`).
See `$DOTFILES/plugins/AGENTS.md` for dotfiles plugin conventions.

## Git

- Default: commit directly to `main`. Do not create a topic branch unless I ask,
  or the project clearly uses a PR-based flow.
- Branch names (when branching): web-case (`fix-the-thing`, not `fixTheThing`)
- Commits: imperative tense, no trailing period; blank line before body if needed
- Integration (only when a branch exists): rebase onto main, then non-fast-forward merge
- Every commit on main must compile with passing tests (for `git bisect`)

## Comments

- Only when surprising — `Note:` for rationale, `HACK:` for dirty/confusing code
- Use complete sentences including terminating period symbols

## Never Do Unless Asked

- Push or pull changes to/from git remotes

# Curtis's AI Assistant Guide

## Environment

- Shell: zsh + oh-my-zsh, vi-mode
- Dotfiles: `~/code/ctrueden/dotfiles`
- Projects: `~/code/<org>/<repo>` cloned from `git@github.com:<org>/<repo>`

## Sub-rules

Read the relevant file(s) before working in that domain:

- `$DOTFILES/rules/python.md` — uv tooling, pytest, pyproject.toml conventions
- `$DOTFILES/rules/java.md` — Maven, SciJava BOM, JUnit, CI patterns
- `$DOTFILES/rules/git.md` branch naming, commit style, rebase/merge workflow

## Language Hints

**Python**: Use `uv` — `uv run python` (not `python3`), `uv add` (not `pip install`),
`uv sync` to install deps. Never invoke bare `python3` or `pip`.

**Java**: Maven-based, typically extending `org.scijava:pom-scijava` parent POM.
Maintained orgs: scijava, imglib, scifio, apposed, imagej, fiji, trackmate, trakem2.

**Kotlin**: Maven for standard projects; Gradle only for KMP/Native (e.g., appose/jaunch).

**Shell**: POSIX-compatible `.sh` unless zsh-specific (`.zsh`) or bash-specific (`.bash`).
See `plugins/AGENTS.md` for dotfiles plugin conventions.

## Git

- Branch names: web-case (`fix-the-thing`, not `fixTheThing`)
- Commits: imperative tense, no trailing period; blank line before body if needed
- Integration: rebase topic branch onto main, then non-fast-forward merge
- Every commit on main must compile with passing tests (for `git bisect`)

## Comments

- Only when surprising — `Note:` for rationale, `HACK:` for dirty/confusing code
- End-of-line comments end with a period

## Never Do Unless Asked

- Push or pull changes to/from git remotes

# Working with Claude

This document summarizes how I work with Claude.ai across all projects.

## My Environment

- **Shell**: zsh with oh-my-zsh, zpm package manager, vi-mode
- **Dotfiles**: `~/code/ctrueden/dotfiles`
- **Preferred tools**: git, vim, z (jump)
- **Platform**: Linux

## Communication Preferences

- **Verbosity**: Concise and direct - minimize output tokens
- **Style**: No unnecessary preamble/postamble, get straight to the point
- **Planning**: Use TodoWrite tool for multi-step tasks
- **Code**: Follow existing conventions, no comments for self-documenting code unless asked

## Standard Project Structure

```
spec/
├── REQUIREMENTS.md     # What we're building and why
├── ARCHITECTURE.md     # How components fit together
├── DECISIONS.md        # Key choices made and rationale
└── TASKS.md            # Current and upcoming work
```

## Workflow

1. **Session start**: "Read my ~/code/ctrueden/brain/CLAUDE.md, then read this project's spec/"
2. **Planning**: Break complex tasks into todos, mark progress as we go
3. **Implementation**: Follow existing patterns, run lint/typecheck when available
4. **Verification**: Test solutions, never assume test frameworks

## Code Preferences

- **Style**: Match existing codebase conventions exactly
- **Libraries**: Always verify dependencies exist before using
- **Security**: Never expose secrets, follow best practices
- **Comments**: Only add when explicitly requested

### Language/Framework Preferences

**Java**: Maven-based projects, typically extending `org.scijava:pom-scijava` parent POM/BOM
- Maintained orgs: scijava, imglib, scifio, apposed, imagej, fiji, trackmate, trakem2
- Projects in `~/code/<org>/<repo>` (cloned from `git@github.com:<org>/<repo>`)

**Python**: uv-based projects preferred
- Modern uv projects: appose/appose-python, scijava/scyjava, imglib/imglyb, imagej/pyimagej, napari/napari-imagej
- Legacy projects needing uv migration: ctrueden/habitica-tools, ctrueden/monoqueue, music/ibroadcast-python, music/beets-config

**Kotlin**: Maven for standard projects, Gradle only for KMP/Native (e.g., appose/jaunch)

**Shell**: Love shell scripting
- Personal: `~/code/ctrueden/dotfiles/bin`
- Professional: `~/code/scijava/scijava-scripts`
- Local-only: `~/bin` (should promote to dotfiles more often)

### Testing & Build

**Java**: JUnit for testing
**Python**: pytest for testing, Makefile with standard targets:
- `make check`: Ensure uv is installed
- `make clean`: Remove build artifacts and intermediate files
- `make lint`: Use ruff et al to tidy code
- `make test`: Run automated tests
- `make dist`: Gather project outputs into `dist/` folder in preparation for release

### Project Examples
All projects organized under `~/code/<org>/<repo>` - use any mentioned projects as reference for patterns and conventions
- **Java template**: `~/code/scijava/parsington` (standard Maven layout)
- **Python template**: `~/code/imagej/pyimagej` (`src/` layout with `pyproject.toml`)

### Git Workflow
- **Branches**: Single integration branch (main) with topic branches, web-case naming
- **Commits**: Simple imperative tense sans period, longer description below
- **Integration**: Rebase topic branches, non-fast-forward merge to preserve feature history
- **Quality**: Every commit on main must compile with passing tests (for `git bisect`)
- **Releases**: Use `release-version.sh` from scijava/scijava-scripts for Java

### CI/CD
GitHub Actions with simple pattern:
- Single `.github/workflows/build.yml`
- Calls `.github/setup.sh` and `.github/build.sh`
- Use `github-actionify.sh` from scijava-scripts for SciJava-based projects

### Project Management
- **Issues**: GitHub Issues
- **Planning**: GitHub Projects + context Markdown files
- **Communication**: Just do things, git allows rollback if needed
- **Context**: Share your thinking - it's valuable

### Domain Focus
Research software engineer in bioimaging:
- Primary maintainer of Fiji (ImageJ distribution)
- General-purpose tools: Jaunch (Java/Python launcher), Appose (Java/Python cooperation)
- Side projects: music metadata (beets), emulation (rommer), D&D campaign

### Documentation & Comments
- **Inline docs**: Javadoc (Java), docstrings (Python) preferred
- **Comments**: Use when code is surprising - "Note:" for rationale, "HACK:" for dirty/confusing code
- **Error handling**: Fail fast generally
- **Doc folders**: Use `doc/` for project documentation
  - Simple example: `~/code/appose/jaunch/doc/`
  - Complex example: `~/code/imagej/pyimagej/doc/`

## Never Do Unless Asked

- Push or pull changes to/from git remotes

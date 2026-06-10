# Java Rules

## Build System

Maven. Most projects extend `org.scijava:pom-scijava` parent POM/BOM.

Reference layout: `~/code/scijava/parsington`

## Key Aliases (dotfiles)

- `b` — `lic -q && mvn clean install` (full build with license update)
- `bs` — `mvn clean install -DskipTests -Denforcer.skip`

## JDK Version Switching

The shell defaults to JDK 8, but SciJava POMs require 11+. Don't hardcode JDK
paths; use the dotfiles tooling:

- `jlist [pattern]` — list installed JDKs (`version<TAB>path`); `bin/java/` script.
- `jhome [pattern]` — print the first matching JDK path; `bin/java/` script.
- `jswitch <pattern>` — set `JAVA_HOME` in the current shell; `java.sh` function.
  Aliases: `j8`, `j11`, `j17`, `j21`, … (and `jg11`/`jg17`/… for GraalVM).

`jlist`/`jhome` are pure-query scripts on `PATH`, so they work non-interactively
(scripts, CI, agents). For a one-off build on a specific JDK without changing the
shell:

    JAVA_HOME=$(jhome "^17") mvn ...

`jswitch` must stay a shell function (it exports into the current shell).

## Testing

JUnit.

## Release

`release-version.sh` from `~/code/scijava/scijava-scripts`.

## CI/CD

GitHub Actions pattern:
- Single `.github/workflows/build.yml`
- Delegates to `.github/setup.sh` and `.github/build.sh`
- Bootstrap via `github-actionify.sh` from scijava-scripts

## Kotlin

Maven for standard Kotlin projects; Gradle only for KMP/Native (e.g., appose/jaunch).

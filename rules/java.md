# Java Rules

## Build System

Maven. Most projects extend `org.scijava:pom-scijava` parent POM/BOM.

Reference layout: `~/code/scijava/parsington`

## Key Aliases (dotfiles)

- `b` — `lic -q && mvn clean install` (full build with license update)
- `bs` — `mvn clean install -DskipTests -Denforcer.skip`

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

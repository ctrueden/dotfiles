# Git Workflow

## Branches

- Naming: web-case (`fix-the-thing`, `add-feature-x`)
- Base: topic branches off `main`

## Commits

- Message: imperative tense, no trailing period (`Fix null pointer in parser`)
- Body: blank line then longer description if needed
- Every commit on `main` must compile with passing tests (supports `git bisect`)

## Integration

1. Work on topic branch
2. Rebase onto main: `grim` (dotfiles alias)
3. Merge with `--no-ff` to preserve feature history

## Useful Aliases (dotfiles)

- `gs` / `c` — status (c also clears + ls)
- `grim` — rebase against main/master (auto-detects)
- `gri [n]` — interactive rebase
- `gll [n]` — last N commits with patches

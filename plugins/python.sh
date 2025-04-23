test "$DEBUG" && echo "[dotfiles] Loading plugin 'python'..."

pypath() { python -c 'import sys; print("\n".join(sys.path))'; }

# --== uv ==--

if [ ! -x "$(command -v uv)" ]; then
  # Install uv via pip if possible.
  if [ -x "$(command -v pip)" ]; then
    pip install --user uv
  fi
fi

if [ -x "$(command -v uv)" ]; then
  # Enable uv shell completion.
  eval "$(uv generate-shell-completion zsh)"

  # Add uv convenience shorthands.
  alias uvi='uv tool install'
  alias uvu='uv tool uninstall'
  alias uvl='uv tool list'
  uve() {
: << 'DOC'
Install the Python project in the current working directory as a uv tool,
replacing any previous installation. As usual with `uv tool install`,
there will be a symlink in `~/.local/bin` pointing to
`~/.local/share/uv/tools/<pkgname>/bin/<exename>`, but in this case, the
tool's source is copied from the local computer, not from the Internet.

Intended as an approximate replacement for `pip install -e . --user`,
although the installed tool is not hotlinked, so ignores future code changes.
DOC
    test -e pyproject.toml || { >&2 echo '[ERROR] No pyproject.toml.'; exit 1; }
    proj=$(grep '^[ \t]*name[ \t]*=' pyproject.toml |
      sed "s/name[ \t]*=[ \t]*[\"']\([^\"']*\).*/\1/")
    test "$proj" || { >&2 echo '[ERROR] Cannot discern project name.'; exit 2; }
    uv tool install --reinstall-package "$proj" --from . "$proj"
  }
fi

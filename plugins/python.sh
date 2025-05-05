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
  eval "$(uv generate-shell-completion $(shell_name))"

  # Add uv convenience shorthands.
  alias uvi='uv tool install'
  alias uvu='uv tool uninstall'
  alias uvl='uv tool list'
  uve() {
: << 'DOC'
Install the Python project in the current working directory as an editable
tool, replacing any previous installation. As usual with `uv tool install`,
there will be a symlink in `~/.local/bin` pointing to
`~/.local/share/uv/tools/<pkgname>/bin/<exename>`, but in this case, the
tool's source is linked from a local working copy, not downloaded or copied.

Intended as an approximate replacement for `pip install -e . --user`,
although the hotlinked tool is installed into its own isolated environment.
DOC
    test -e pyproject.toml || { >&2 echo '[ERROR] No pyproject.toml.'; exit 1; }
    proj=$(grep '^[ \t]*name[ \t]*=' pyproject.toml |
      sed "s/name[ \t]*=[ \t]*[\"']\([^\"']*\).*/\1/")
    test "$proj" || { >&2 echo '[ERROR] Cannot discern project name.'; exit 2; }
    uv tool install --reinstall-package "$proj" --with-editable . "$proj"
  }
fi

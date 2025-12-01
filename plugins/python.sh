test "$DEBUG" && echo "[dotfiles] Loading plugin 'python'..."

py() {
  if command -v python >/dev/null 2>&1; then
    python "$@"
  elif command -v python3 >/dev/null 2>&1; then
    python3 "$@"
  else
    >&2 echo "[ERROR] No python binary found on the path."
  fi
}
pypath() { py -c 'import sys; print("\n".join(sys.path))'; }

alias py38='mamba run -n py38 python'
alias py39='mamba run -n py39 python'
alias py310='mamba run -n py310 python'
alias py311='mamba run -n py311 python'
alias py312='mamba run -n py312 python'
alias py313='mamba run -n py313 python'
alias py314='mamba run -n py314 python'

# --== pip ==--

pip=$(command -v pip)
test -x "$pip" || pip=$(command -v pip3)
if [ -x "$pip" ]; then
  export PIP="$pip"
else
  # Some pip installations will probably not be on the path yet,
  # so we'll look for them explicitly here to improve our chances.
  for pip in "$MAMBA_DIR/bin/pip"; do
    if [ -x "$(command -v "$pip")" ]; then
      export PIP="$pip"
      break
    fi
  done
fi

# --== uv ==--

# Note: ~/.local/bin is not yet on the PATH; see zzz_path.sh.
case "$(uname)" in
  Darwin) UV=$(printf "$HOME"/Library/Python/*/bin/uv) 2>/dev/null ;;
  Linux) UV="$HOME"/.local/bin/uv ;;
  *) UV= ;;
esac
if [ ! -x "$UV" ]; then
  # Install uv via pip if possible.
  if [ -x "$PIP" ]; then
    "$PIP" install --user uv ||
    "$PIP" install --break-system-packages --user uv
  fi
fi

if [ -x "$UV" ]; then
  # Enable uv shell completion.
  eval "$("$UV" generate-shell-completion $(shell_name))"
  # Fix completions for uv run to autocomplete .py files.
  # Credit: https://github.com/astral-sh/uv/issues/8432#issuecomment-2965692994
  _uv_run_mod() {
    if [[ "$words[2]" == "run" && "$words[CURRENT]" != -* ]]; then
      _arguments '*:filename:_files -g "*.py"'
    else
      _uv "$@"
    fi
  }
  compdef _uv_run_mod uv

  # Add uv convenience shorthands.
  alias uvp='uv run python'
  alias uvr='uv run'
  alias urv=uvr
  alias uvi='uv tool install'
  alias uvu='uv tool uninstall'
  alias uvl='uv tool list'
  alias uvd=deactivate
  uva() {
: << 'DOC'
Activate a uv-based Python environment. The optional argument can be:
* The name of a uv-installed tool (from an earlier `uv tool install`).
* A relative or absolute directory path to a uv environment.
Or no argument to activate the .venv in the current project directory.
DOC
    local d
    if [ $# -gt 0 ]; then
      # First, look for a tool directory with this name.
      d="$HOME/.local/share/uv/tools/$1"
      # If no such tool is installed, assume it's a plain directory path.
      test -d "$d" || d="$1"
    else
      # No argument given; assume we are in a uv project directory.
      d=.venv
    fi
    test -d "$d" || { >&2 echo "[ERROR] No env directory for $d"; return 1; }
    source "$d/bin/activate"
  }
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
    test -e pyproject.toml || { >&2 echo '[ERROR] No pyproject.toml.'; return 1; }
    local proj=$(grep '^[ \t]*name[ \t]*=' pyproject.toml |
      sed "s/name[ \t]*=[ \t]*[\"']\([^\"']*\).*/\1/")
    test "$proj" || { >&2 echo '[ERROR] Cannot discern project name.'; return 2; }
    uv tool install --reinstall-package "$proj" --with-editable . "$proj"
  }
fi

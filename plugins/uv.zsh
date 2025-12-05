test "$DEBUG" && echo "[dotfiles] Loading zsh plugin 'uv'..."

if [ -x "$UV" ]; then
  # Fix completions for uv run to autocomplete .py files.
  # Credit: https://github.com/astral-sh/uv/issues/8432#issuecomment-2965692994
  _uv_run_mod() {
    if [[ "$words[2]" == "run" && "$words[CURRENT]" != -* ]]; then
      _arguments '*:filename:_files -g "*.py"'
    else
      _uv "$@"
    fi
  }
  # Note: compdef does not work with bash.
  compdef _uv_run_mod uv
fi

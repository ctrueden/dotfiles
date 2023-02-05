test "$DEBUG" && echo "[dotfiles] Loading plugin 'pass'..."

comp_pass_bash="$HOME/.local/share/bash_completions/completions/pass.bash-completion"
if [ ! -f "$comp_pass_bash" ]
then
  echo "Installing bash completion for pass..."
  mkdir -p "${comp_pass_bash%/*}"
  curl -fsL https://git.zx2c4.com/password-store/plain/src/completion/pass.bash-completion > "$comp_pass_bash"
fi

if command -v compdef >/dev/null
then
  comp_pass_zsh="$HOME/.zpm/functions/pass.zsh-completion"
  if [ ! -f "$comp_pass_zsh" ]
  then
    echo "Installing zsh completion for pass..."
    mkdir -p "${comp_pass_zsh%/*}"
    curl -fsL https://git.zx2c4.com/password-store/plain/src/completion/pass.zsh-completion > "$comp_pass_zsh"
  fi
  compdef _pass pass
fi

pclip() {
  : << 'DOC'
Search for a matching password entry and copy the password to the clipboard.
DOC
  test "$#" -gt 0 || {
    >&2 echo "Usage: pclip search-term [another-search-term ...]"
    return 1
  }
  result=$(cd ~/.password-store && git ls-files)
  while [ $# -gt 0 ]
  do
    result=$(printf '%s\n' "$result" | grep -i "$1")
    shift
  done
  test "$result" || {
    >&2 echo "[ERROR] No matching passwords."
    return 2
  }
  test "$(echo "$result" | wc -l)" -eq 1 || {
    >&2 echo "[ERROR] Multiple matching passwords:"
    echo "$result" | sed -e 's;.*\.password-store/;;' -e 's;\.gpg$;;'
    return 3
  }
  result=${result#*.password-store/}
  result=${result%*.gpg}
  pass show -c "$result"
}

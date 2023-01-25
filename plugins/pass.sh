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

test "$DEBUG" && echo "[dotfiles] Loading plugin 'shell'..."

# Which shell am I running? zsh? bash?
shell_name() { ps -p $$ | tail -n1 | sed 's/.* //'; }

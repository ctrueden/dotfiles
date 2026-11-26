# Note: zsh reads this for every shell, interactive or not, so that commands
# run via zsh -c (e.g. from tmux popups) find the same tools.
setopt interactivecomments
. "$DOTFILES"/lib/env.sh
. "$DOTFILES"/lib/path.sh

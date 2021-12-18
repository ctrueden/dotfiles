test "$DEBUG" && echo "[dotfiles] Loading zsh plugin 'zmv'..."

# --== zmv ==--

# See: https://github.com/zsh-users/zsh/blob/master/Functions/Misc/zmv

autoload -U zmv
alias mmv='noglob zmv -W'

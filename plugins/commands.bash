test "$DEBUG" && echo "[dotfiles] Loading bash plugin 'commands'..."

# --== bash command shortcuts ==--

# The oh-my-zsh project has lots of useful command shortcuts.
# Unfortunately, they aren't available in bash.
# So we replicate a few good ones here. But only for bash.
# In this way, as oh-my-zsh improves, we will receive those improvements,
# but only when using zsh. But bash users will have something, at least.

alias l='ls -lah'
alias la='ls -lAh'
alias ll='ls -lh'
alias lsa='ls -lah'

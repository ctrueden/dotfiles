test "$DEBUG" && echo "[dotfiles] Loading zsh plugin 'keyboard-fixes'..."

# --== zsh keyboard fixes ==--

# Make numpad keys work as expected even with NumLock off.
# Credit to: https://superuser.com/a/742193
bindkey -s "^[Ok" "+"
bindkey -s "^[Om" "-"
bindkey -s "^[Oj" "*"
bindkey -s "^[Oo" "/"
bindkey -s "^[OE" "" # numpad 5
bindkey -s "^[OM" "^M" # Enter

# NB: I don't know how many of these fixes are still necessary
# with the latest and greatest oh-my-zsh vi mode support...

# Credit to: http://zshwiki.org/home/zle/vi-mode
bindkey -a 'gg' beginning-of-buffer-or-history
bindkey -a 'g~' vi-oper-swap-case
bindkey -a G end-of-buffer-or-history
bindkey -a u undo
bindkey -a '^R' redo
bindkey '^G' what-cursor-position
vi-backward-word-end() {
	zle vi-forward-word-end
	zle vi-backward-word -n 2 && zle vi-forward-word-end
}
vi-backward-blank-word-end() {
	zle vi-forward-blank-word-end
	zle vi-backward-blank-word -n 2 && zle vi-forward-blank-word-end
}

# Make delete key work properly
# Credit to: https://zsh.sourceforge.io/Guide/zshguide04.html#l81
bindkey '\e[3~' delete-char

# Credit to: https://superuser.com/a/533685
vi-search-fix() {
	zle vi-cmd-mode
	zle .vi-history-search-backward
}
autoload vi-search-fix
zle -N vi-search-fix
bindkey -M viins '\e/' vi-search-fix
bindkey "^?" backward-delete-char
bindkey "^W" backward-kill-word
bindkey "^H" backward-delete-char
bindkey "^U" backward-kill-line
# Credit to: https://superuser.com/a/648046
export KEYTIMEOUT=1
bindkey -sM vicmd '^[' '^G'
bindkey -rM viins '^X'
bindkey -M viins '^X,' _history-complete-newer \
                 '^X/' _history-complete-older \
                 '^X`' _bash_complete-word

test "$DEBUG" && echo "[dotfiles] Loading plugin 'vim'..."

which vundle-init >/dev/null 2>&1 &&
	test ! -d "$HOME/.vim/bundle/Vundle.vim" &&
	vundle-init && vundle-update

alias vi='vim'
alias :e='vim'

# use vim to edit commit messages
export EDITOR=vim
export VISUAL="$EDITOR"

# search for the given filename in the current subtree and open in vim
# Requires: plugins/nav
vif() { vim $(wi "$@"); }

# grep for a particular string and open all matching files in vim
vig() { vim $(grep -l $@); }

# format the clipboard as an email quote
alias viq="vi \
	+'set tw=72' \
	+'normal! \"+p' \
	+':silent :1g/^$/d' \
	+':silent :g/^/s//> /' \
	+'normal! 1GVGgq1G\"+yG'"

test "$DEBUG" && echo "[dotfiles] Loading plugin 'vim'..."

which vundle-init >/dev/null 2>&1 &&
	test ! -d "$HOME/.vim/bundle/Vundle.vim" &&
	vundle-init && vundle-update

# search for the given filename in the current subtree and open in vim
# Requires: plugins/nav
vif() { vim $(wi "$@"); }

# grep for a particular string and open all matching files in vim
vig() { vim $(grep -l $@); }

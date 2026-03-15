test "$DEBUG" && echo "[dotfiles] Loading plugin 'vim'..."

# Set up vim command aliases.
if [ "$(command -v nvim)" ]
then
	alias vi='nvim'
	alias vim='nvim'
	alias :e='nvim'
	export EDITOR=nvim
elif [ "$(command -v vim)" ]
then
	alias vi='vim'
	alias :e='vim'
	export EDITOR=vim
elif [ "$(command -v vi)" ]
then
	alias vim='vi'
	alias :e='vi'
	export EDITOR=vi
fi

# use nvim/vim/vi to edit commit messages
test -z "$EDITOR" || export VISUAL="$EDITOR"

# search for the given filename in the current subtree and open in vim
# Requires: plugins/nav
vif() { vi $(wi "$@"); }

# grep for a particular string and open all matching files in vim
vgrp() { grpl -z $@ | xargs -0o vi; }

# ripgrep for a particular string and open all matching files in vim
vrg() { rg -l0 $@ | xargs -0o vi; }

# format the clipboard as an email quote
alias viq="vi \
	+'set tw=72' \
	+'normal! \"+p' \
	+':silent :1g/^$/d' \
	+':silent :g/^/s//> /' \
	+'normal! 1GVGgq1G\"+yG'"

# Set up vim command aliases.
# Note: lib/editor.sh sets EDITOR and VISUAL, before the multiplexer starts.
if has nvim
then
	alias vi='nvim'
	alias vim='nvim'
	alias :e='nvim'
elif has vim
then
	alias vi='vim'
	alias :e='vim'
elif has vi
then
	alias vim='vi'
	alias :e='vi'
fi

# search for the given filename in the current subtree and open in vim
# Requires: plugins/nav
vif() { "$EDITOR" $(wi "$@"); }

# grep for a particular string and open all matching files in vim
vgrp() { grpl -z "$@" | xargs -0o vi; }

# ripgrep for a particular string and open all matching files in vim
vrg() { rg -l0 "$@" | xargs -0o vi; }

# format the clipboard as an email quote
alias viq="vi \
	+'set tw=72' \
	+'normal! \"+p' \
	+':silent :1g/^$/d' \
	+':silent :g/^/s//> /' \
	+'normal! 1GVGgq1G\"+yG'"

test "$DEBUG" && echo "[dotfiles] Loading plugin 'vars'..."

# --== Homebrew ==--

if [ -x "$(command -v brew)" ]; then
	export BREW="$(brew --prefix)"
fi

# --== CVS ==--

export CVS_RSH=ssh

# --== SVN ==--

# do not autocomplete .svn folders
export FIGNORE=.svn

# --== Python sphinx ==--

# fail the sphinx build when there are warnings
export SPHINXOPTS=-W

# --== less ==--

# enable syntax highlighting in less, and disable page clearing on quit
export LESS=-RX
if [ -d /usr/share/source-highlight ]; then
	export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
elif [ -d $HOME/brew/Cellar/source-highlight ]; then
	export LESSOPEN="| $HOME/brew/Cellar/source-highlight/*/bin/src-hilite-lesspipe.sh %s"
fi

# --== xmllint ==--

# indent XML with tabs
export XMLLINT_INDENT=$'\t'

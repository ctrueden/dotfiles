# --== Homebrew ==--

# Note: lib/path.sh finds Homebrew in its usual places.
if [ -z "$BREW" ] && has brew; then
	export BREW="$(brew --prefix)"
fi

# --== starship ==--

# read the prompt config straight from the dotfiles
export STARSHIP_CONFIG="$DOTFILES/starship.toml"

# --== jgo ==--

# read the jgo config straight from the dotfiles (jgo 3.2.0+)
export JGO_CONFIG_FILE="$DOTFILES/jgo.conf"

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

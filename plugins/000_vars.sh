# --== Homebrew ==--

# Note: lib/path.sh finds Homebrew in its usual places.
if [ -z "$BREW" ] && has brew; then
	export BREW="$(brew --prefix)"
fi
test -d "$BREW" && . "$DOTFILES/lib/brew.sh"

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

# pass color codes through in less, and disable page clearing on quit
export LESS=-RX

# let less show the contents of archives, packages, and documents
# Note: Plain text passes through untouched; for highlighting, use bat.
if has lesspipe; then
	# Debian/Ubuntu (part of the less package); also sets LESSCLOSE.
	eval "$(SHELL=/bin/sh lesspipe)"
elif has lesspipe.sh; then
	# Homebrew's lesspipe, a different program with the same purpose.
	export LESSOPEN="|lesspipe.sh %s"
fi

# --== xmllint ==--

# indent XML with tabs
export XMLLINT_INDENT=$'\t'

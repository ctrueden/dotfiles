test "$DEBUG" && echo "[dotfiles] Loading plugin 'vars'..."

# --== Early PATH update ==--
#
# Plugins load alphabetically, with zzz_path.sh running last to do the final
# PATH assembly. But some plugins (python.sh, etc.) need to discover tools via
# `command -v`, which requires those tools to already be on PATH. We therefore
# add user-local bin dirs here and flush them immediately, so all subsequent
# plugins can find tools installed there.
#
# Only unconditional, variable-free dirs belong here -- dirs that depend on a
# variable (e.g. $MAMBA_DIR, $BREW) must be handled in the plugin that sets
# that variable. System/Homebrew dirs stay in zzz_path.sh where load order
# relative to other plugins doesn't matter.
path_prepend "$HOME/.local/bin"                 # pip --user, uv (Linux)
macPythonDir=$(echo "$HOME"/Library/Python/*/bin | head -n1) 2>/dev/null
path_prepend "$macPythonDir"                    # pip --user (macOS)
path_prepend "$HOME/bin"                        # personal scripts
path_update

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

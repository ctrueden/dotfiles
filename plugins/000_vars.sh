# use vim to edit commit messages
export EDITOR=vim
export VISUAL="$EDITOR"

# --== Homebrew ==--

if [ -x "$(which brew)" ]; then
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

# enable syntax highlighting in less
export LESS=' -R '
if [ -d /usr/share/source-highlight ]; then
	export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
elif [ -d $HOME/brew/Cellar/source-highlight ]; then
	export LESSOPEN="| $HOME/brew/Cellar/source-highlight/*/bin/src-hilite-lesspipe.sh %s"
fi

# --== xmllint ==--

# indent XML with tabs
export XMLLINT_INDENT=$'\t'

# --== git-svn ==--

# tell git-svn where to find SVN authors
export SVN_AUTHORS="$PATH_CFG_PRIVATE/authors.txt"

# --== Git-Mediawiki (https://github.com/moy/Git-Mediawiki/wiki) ==--

# Install prerequisites:
# cpan MediaWiki::API
# cpan DateTime::Format::ISO8601

# Put git-remote-mediawiki and git-mw somewhere on your PATH:
# ln -s "$PATH_GIT/contrib/mw-to-git/git-remote-mediawiki.perl" \
#       ~/bin/git-remote-mediawiki
# ln -s "$PATH_GIT/contrib/mw-to-git/git-mw" ~/bin

export PERL5LIB="$PATH_GIT/perl:$PATH_GIT/contrib/mw-to-git"

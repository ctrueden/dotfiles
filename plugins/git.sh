# Git - https://github.com/git/git
export PATH_GIT="$PATH_CODE/git/git"
alias gogit='cd $PATH_GIT'

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

# Git - https://github.com/git/git
export CODE_GIT="$CODE_BASE/git/git"
alias gogit='cd $CODE_GIT'

# --== git-svn ==--

# tell git-svn where to find SVN authors
export SVN_AUTHORS="$CODE_CFG_PRIVATE/authors.txt"

# --== Git-Mediawiki (https://github.com/moy/Git-Mediawiki/wiki) ==--

# Install prerequisites:
# cpan MediaWiki::API
# cpan DateTime::Format::ISO8601

# Put git-remote-mediawiki and git-mw somewhere on your CODE:
# ln -s "$CODE_GIT/contrib/mw-to-git/git-remote-mediawiki.perl" \
#       ~/bin/git-remote-mediawiki
# ln -s "$CODE_GIT/contrib/mw-to-git/git-mw" ~/bin

export PERL5LIB="$CODE_GIT/perl:$CODE_GIT/contrib/mw-to-git"

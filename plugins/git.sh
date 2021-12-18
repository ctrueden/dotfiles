test "$DEBUG" && echo "[dotfiles] Loading plugin 'git'..."

# Git - https://github.com/git/git
export CODE_GIT="$CODE_BASE/git/git"
alias gogit='cd $CODE_GIT'

# use git for superior diff formatting
alias diff='' && unalias diff
diff() { git diff --no-index $@; }

# --== shortcuts =-

# alias some common git typos
alias giot='git'
alias goit='git'
alias got='git'
alias gti='git'

# These complement the ones defined by oh-my-zsh's git plugin.

alias conflicts!='git diff --name-only --diff-filter=U --no-prefix'
alias conflicts='git diff --name-only --diff-filter=U'
alias gbv='git branch -avv'
alias gcpo='git cherry-pick --strategy=recursive --strategy-option=ours'
alias gcpt='git cherry-pick --strategy=recursive --strategy-option=theirs'
alias gd!='git diff --no-prefix'
alias gdbl='git diff-blame'
alias gdcw!='git diff --color-words --no-prefix'
alias gdcw.!='git diff --color-words --word-diff-regex=. --no-prefix'
alias gdcw.='git diff --color-words --word-diff-regex=.'
alias gdcw='git diff --color-words'
alias gds!='git diff --staged --no-prefix'
alias gdscw!='git diff --staged --color-words --no-prefix'
alias gdscw.!='git diff --staged --color-words --word-diff-regex=. --no-prefix'
alias gdscw.='git diff --staged --color-words --word-diff-regex=.'
alias gdscw='git diff --staged --color-words'
alias gfat='gfa && git fetch --all --tags'
alias gfb='git filter-branch -f --prune-empty'
alias gfbi='git filter-branch -f --prune-empty --index-filter'
alias gfbs='git filter-branch -f --prune-empty --subdirectory-filter'
alias gfbt='git filter-branch -f --prune-empty --tree-filter'
alias gff='git merge --ff --ff-only '\''HEAD@{u}'\'
alias gffs='git stash && gff && gpop'
alias glns='git log --name-status'
alias glnsf='git log --name-status --follow'
alias gls='git ls-files'
alias gmv='git mv'
alias gpack='git reflog expire --expire=now --all && git gc --aggressive --prune=now'
alias gpop!='git checkout '\''stash^{tree}'\'' -- . && git stash drop'
alias gpop='git stash pop --index'
alias gps=gp
alias grhup='git reset --hard '\''HEAD@{u}'\'
alias grup!='grup --prune'
alias gsh!='gsh --no-prefix'
alias gshcw!='gsh --color-words --no-prefix'
alias gshcw.!='gsh --color-words --word-diff-regex=. --no-prefix'
alias gshcw.='gsh --color-words --word-diff-regex=.'
alias gshcw='gsh --color-words'
alias gtags='git fetch --tags && git tag -l --sort=taggerdate'
alias gum='git cherry -v master'
alias gws='git rebase --whitespace=strip'
alias wikiclone='clone -c '\''remote.origin.mediaimport=true'\'' -c '\''remote.origin.mediaexport=true'\'' -c '\''remote.origin.namespaces=(Main) File Template'\'
ghelp() {
  alias | grep git | grep "$@"
  for cmd in $(declare -f | grep '^[a-z]\+ () {$' | sed 's/^\([a-z]*\).*/\1/')
  do
    func=$(which "$cmd")
    echo "$func" | grep -q git &&
    echo "$func" | grep -q "$@" &&
    echo "$func" | grep -C9999 "$@"
  done
}
gll() {
  local num=$(echo "$1" | sed 's/[^0-9]//g')
  shift
  test "$num" || num=1
  glgp -$num $@
}
gri() {
  local ref=''
  case $# in
    0)
      # If nothing is given, rebase against upstream.
      ref='HEAD@{u}'
      ;;
    1)
      # If a number is given, rebase that many commits back.
      if echo "$1" | grep -q '^[0-9]\+$'; then ref="HEAD~$1"; shift; fi
      ;;
  esac
  if [ "$ref" ]; then grbi "$ref" $@; else grbi $@; fi
}
gtagsv() {
  gtags | while read tag
  do
    echo "$(git rev-parse "$tag")\t$tag"
  done
  for remote in $(git remote)
  do
    echo "[$remote]" && git ls-remote $remote | grep '/tags/'
  done
}

# --== git-svn ==--

# tell git-svn where to find SVN authors
export SVN_AUTHORS="$CODE_CFG_PRIVATE/authors.txt"

# --== Git-Mediawiki (https://github.com/moy/Git-Mediawiki/wiki) ==--

# Install prerequisites:
# cpan MediaWiki::API
# cpan DateTime::Format::ISO8601

# Put git-remote-mediawiki and git-mw somewhere on your PATH:
# ln -s "$CODE_GIT/contrib/mw-to-git/git-remote-mediawiki.perl" \
#       ~/bin/git-remote-mediawiki
# ln -s "$CODE_GIT/contrib/mw-to-git/git-mw" ~/bin

export PERL5LIB="$CODE_GIT/perl:$CODE_GIT/contrib/mw-to-git"


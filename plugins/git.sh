test "$DEBUG" && echo "[dotfiles] Loading plugin $(basename "$0")..."

# Git - https://github.com/git/git
export CODE_GIT="$CODE_BASE/git/git"
alias gogit='cd $CODE_GIT'

# --== shortcuts =-

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
alias gps='fix-git-remotes && gp'
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
ghr() {
  local slug=$1
  test "$slug" || slug=$(git remote -v | cut -d"$(echo "\t")" -f2 | head -n1 | sed 's/.*github.com\/\([^ ]*\).*/\1/')
  test "$slug" &&
  git remote set-url origin "git://github.com/$slug" && git remote set-url --push origin "git@github.com:$slug"
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

# --== bash shortcuts ==--

# The git oh-my-zsh plugin has lots of useful shortcuts.
# Unfortunately, they aren't available in bash.
# So, sadly, we replicate most of them here. But only for bash.
# In this way, as oh-my-zsh improves, we will receive those improvements,
# but only when using zsh. But bash users will have something, at least.

if [ "$(shell_name)" != zsh ]
then
  # NB: Code adapted from:
  # https://github.com/ohmyzsh/ohmyzsh/blob/95a06f39/plugins/git/git.plugin.zsh

  alias g='git'

  alias ga='git add'
  alias gaa='git add --all'
  alias gapa='git add --patch'
  alias gau='git add --update'
  alias gav='git add --verbose'
  alias gap='git apply'
  alias gapt='git apply --3way'

  alias gb='git branch'
  alias gba='git branch -a'
  alias gbd='git branch -d'
  alias gbda='git branch --no-color --merged | command grep -vE "^(\+|\*|\s*($(git_main_branch)|development|develop|devel|dev)\s*$)" | command xargs -n 1 git branch -d'
  alias gbD='git branch -D'
  alias gbl='git blame -b -w'
  alias gbnm='git branch --no-merged'
  alias gbr='git branch --remote'
  alias gbs='git bisect'
  alias gbsb='git bisect bad'
  alias gbsg='git bisect good'
  alias gbsr='git bisect reset'
  alias gbss='git bisect start'

  alias gc='git commit -v'
  alias gc!='git commit -v --amend'
  alias gcn!='git commit -v --no-edit --amend'
  alias gca='git commit -v -a'
  alias gca!='git commit -v -a --amend'
  alias gcan!='git commit -v -a --no-edit --amend'
  alias gcans!='git commit -v -a -s --no-edit --amend'
  alias gcam='git commit -a -m'
  alias gcsm='git commit -s -m'
  alias gcb='git checkout -b'
  alias gcf='git config --list'
  alias gcl='git clone --recurse-submodules'
  alias gclean='git clean -id'
  alias gpristine='git reset --hard && git clean -dffx'
  alias gcm='git checkout $(git_main_branch)'
  alias gcd='git checkout develop'
  alias gcmsg='git commit -m'
  alias gco='git checkout'
  alias gcount='git shortlog -sn'
  alias gcp='git cherry-pick'
  alias gcpa='git cherry-pick --abort'
  alias gcpc='git cherry-pick --continue'
  alias gcs='git commit -S'

  alias gd='git diff'
  alias gdca='git diff --cached'
  alias gdcw='git diff --cached --word-diff'
  alias gdct='git describe --tags $(git rev-list --tags --max-count=1)'
  alias gds='git diff --staged'
  alias gdt='git diff-tree --no-commit-id --name-only -r'
  alias gdw='git diff --word-diff'

  gdnolock() {
    git diff "$@" ":(exclude)package-lock.json" ":(exclude)*.lock"
  }

  gdv() { git diff -w "$@" | view -; }

  alias gf='git fetch'
  alias gfa='git fetch --all --prune --jobs=10'
  alias gfo='git fetch origin'

  alias gfg='git ls-files | grep'

  alias gg='git gui citool'
  alias gga='git gui citool --amend'

  ggf() {
    test "$#" -ne 1 && local b="$(git_current_branch)"
    git push --force origin "${b:=$1}"
  }
  ggfl() {
    test "$#" -ne 1 && local b="$(git_current_branch)"
    git push --force-with-lease origin "${b:=$1}"
  }

  ggl() {
    if [ "$#" -ne 0 -a "$#" -ne 1 ]; then
      git pull origin "${*}"
    else
      test "$#" -eq 0 && local b="$(git_current_branch)"
      git pull origin "${b:=$1}"
    fi
  }

  ggp() {
    if [ "$#" -ne 0 -a "$#" -ne 1 ]; then
      git push origin "${*}"
    else
      test "$#" -eq 0 && local b="$(git_current_branch)"
      git push origin "${b:=$1}"
    fi
  }

  ggpnp() {
    if [ "$#" -eq 0 ]; then
      ggl && ggp
    else
      ggl "${*}" && ggp "${*}"
    fi
  }

  ggu() {
    test "$#" -ne 1 && local b="$(git_current_branch)"
    git pull --rebase origin "${b:=$1}"
  }

  alias ggpur='ggu'
  alias ggpull='git pull origin "$(git_current_branch)"'
  alias ggpush='git push origin "$(git_current_branch)"'

  alias ggsup='git branch --set-upstream-to=origin/$(git_current_branch)'
  alias gpsup='git push --set-upstream origin $(git_current_branch)'

  alias ghh='git help'

  alias gignore='git update-index --assume-unchanged'
  alias gignored='git ls-files -v | grep "^[[:lower:]]"'
  alias git-svn-dcommit-push='git svn dcommit && git push github $(git_main_branch):svntrunk'

  alias gk='\gitk --all --branches'
  alias gke='\gitk --all $(git log -g --pretty=%h)'

  alias gl='git pull'
  alias glg='git log --stat'
  alias glgp='git log --stat -p'
  alias glgg='git log --graph'
  alias glgga='git log --graph --decorate --all'
  alias glgm='git log --graph --max-count=10'
  alias glo='git log --oneline --decorate'
  alias glol="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'"
  alias glols="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --stat"
  alias glod="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset'"
  alias glods="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset' --date=short"
  alias glola="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --all"
  alias glog='git log --oneline --decorate --graph'
  alias gloga='git log --oneline --decorate --graph --all'
  alias glp="_git_log_prettily"

  alias gm='git merge'
  alias gmom='git merge origin/$(git_main_branch)'
  alias gmt='git mergetool --no-prompt'
  alias gmtvim='git mergetool --no-prompt --tool=vimdiff'
  alias gmum='git merge upstream/$(git_main_branch)'
  alias gma='git merge --abort'

  alias gp='git push'
  alias gpd='git push --dry-run'
  alias gpf='git push --force-with-lease'
  alias gpf!='git push --force'
  alias gpoat='git push origin --all && git push origin --tags'
  alias gpu='git push upstream'
  alias gpv='git push -v'

  alias gr='git remote'
  alias gra='git remote add'
  alias grb='git rebase'
  alias grba='git rebase --abort'
  alias grbc='git rebase --continue'
  alias grbd='git rebase develop'
  alias grbi='git rebase -i'
  alias grbm='git rebase $(git_main_branch)'
  alias grbo='git rebase --onto'
  alias grbs='git rebase --skip'
  alias grev='git revert'
  alias grh='git reset'
  alias grhh='git reset --hard'
  alias groh='git reset origin/$(git_current_branch) --hard'
  alias grm='git rm'
  alias grmc='git rm --cached'
  alias grmv='git remote rename'
  alias grrm='git remote remove'
  alias grs='git restore'
  alias grset='git remote set-url'
  alias grss='git restore --source'
  alias grst='git restore --staged'
  alias grt='cd "$(git rev-parse --show-toplevel || echo .)"'
  alias gru='git reset --'
  alias grup='git remote update'
  alias grv='git remote -v'

  alias gsb='git status -sb'
  alias gsd='git svn dcommit'
  alias gsh='git show'
  alias gsi='git submodule init'
  alias gsps='git show --pretty=short --show-signature'
  alias gsr='git svn rebase'
  alias gss='git status -s'
  alias gst='git status'
  alias gsta='git stash push'
  alias gstaa='git stash apply'
  alias gstc='git stash clear'
  alias gstd='git stash drop'
  alias gstl='git stash list'
  alias gstp='git stash pop'
  alias gsts='git stash show --text'
  alias gstu='git stash --include-untracked'
  alias gstall='git stash --all'
  alias gsu='git submodule update'
  alias gsw='git switch'
  alias gswc='git switch -c'

  alias gts='git tag -s'
  alias gtv='git tag | sort -V'
  alias gtl='gtl(){ git tag --sort=-v:refname -n -l "${1}*" }; noglob gtl'

  alias gunignore='git update-index --no-assume-unchanged'
  alias gunwip='git log -n 1 | grep -q -c "\-\-wip\-\-" && git reset HEAD~1'
  alias gup='git pull --rebase'
  alias gupv='git pull --rebase -v'
  alias gupa='git pull --rebase --autostash'
  alias gupav='git pull --rebase --autostash -v'
  alias glum='git pull upstream $(git_main_branch)'

  alias gwch='git whatchanged -p --abbrev-commit --pretty=medium'
  alias gwip='git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign -m "--wip-- [skip ci]"'

  alias gam='git am'
  alias gamc='git am --continue'
  alias gams='git am --skip'
  alias gama='git am --abort'
  alias gamscp='git am --show-current-patch'

  grename() {
    if [ -z "$1" -o -z "$2" ]; then
      echo "Usage: $0 old_branch new_branch"
      return 1
    fi

    # Rename branch locally
    git branch -m "$1" "$2"
    # Rename branch in origin remote
    if git push origin :"$1"; then
      git push --set-upstream origin "$2"
    fi
  }
fi

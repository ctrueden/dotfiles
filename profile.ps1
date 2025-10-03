$env:CODEBASE = "$HOME\code"

$env:PATH = "$HOME\.local\bin;$env:PATH"

Set-Alias grep sls
Set-Alias less more
Set-Alias which gcm
function asdf { cd "$HOME"; clear }
function c { clear; ls $args }
function gocfg { cd "$env:DOTFILES" }
function up { cd .. }
function up2 { cd ..\.. }
function up3 { cd ..\..\.. }
function up4 { cd ..\..\..\.. }
function up5 { cd ..\..\..\..\.. }
function up6 { cd ..\..\..\..\..\.. }
function up7 { cd ..\..\..\..\..\..\.. }
function up8 { cd ..\..\..\..\..\..\..\.. }
function up9 { cd ..\..\..\..\..\..\..\..\.. }

function vi { cmd /c 'C:\Program Files\Git\usr\bin\vim.exe' $args }

function z {
    param(
        [Parameter(Mandatory=$true)]
        [string]$pattern
    )

    $matches = Get-ChildItem $env:CODEBASE -Directory |
        Get-ChildItem -Directory |
        Where-Object { $_.Name -like "*$pattern*" }

    if ($matches.Count -eq 0) {
        Write-Host "No matches found"
        return 1
    }

    Set-Location $matches[0].FullName
}

# -- Git --

# alias some common git typos
Set-Alias giot git
Set-Alias goit git
Set-Alias got git
Set-Alias gti git

# cover up Ghostscript ;-)
function gs { git status $args }

# These complement the ones defined by oh-my-zsh's git plugin.

function conflicts! { git diff --name-only --diff-filter=U --no-prefix $args }
function conflicts { git diff --name-only --diff-filter=U $args }
function gbv { git branch -avv $args }
function gcpo { git cherry-pick --strategy=recursive --strategy-option=ours $args }
function gcpt { git cherry-pick --strategy=recursive --strategy-option=theirs $args }
function gd! { git diff --no-prefix $args }
function gdbl { git diff-blame $args }
function gdcw! { git diff --color-words --no-prefix $args }
function gdcw.! { git diff --color-words --word-diff-regex=. --no-prefix $args }
function gdcw. { git diff --color-words --word-diff-regex=. $args }
function gdcw { git diff --color-words $args }
function gds! { git diff --staged --no-prefix $args }
function gdscw! { git diff --staged --color-words --no-prefix $args }
function gdscw.! { git diff --staged --color-words --word-diff-regex=. --no-prefix $args }
function gdscw. { git diff --staged --color-words --word-diff-regex=. $args }
function gdscw { git diff --staged --color-words $args }
function gfat { gfa; git fetch --all --tags $args }
function gfb { git filter-branch -f --prune-empty $args }
function gfbi { git filter-branch -f --prune-empty --index-filter $args }
function gfbs { git filter-branch -f --prune-empty --subdirectory-filter $args }
function gfbt { git filter-branch -f --prune-empty --tree-filter $args }
function gff { git merge --ff --ff-only 'HEAD@{u}' $args }
function gffs { git stash; gff; gpop $args }
function glns { git log --name-status $args }
function glnsf { git log --name-status --follow $args }
function gls { git ls-files $args }
function gmv { git mv $args }
function gpack { git reflog expire --expire=now --all; git gc --aggressive --prune=now $args }
function gpop! { git checkout 'stash^{tree}' -- .; git stash drop $args }
function gpop { git stash pop --index $args }
function gps {  $args }
function grhup { git reset --hard 'HEAD@{u}' $args }
#function grim { gri $(git show-ref -q --verify refs/heads/main && echo main || echo master) $args }
function grp { git grep -I $args }
function grpi { git grep -Ii $args }
function grpil { git grep -Iil $args }
function grpin { git grep -Iin $args }
function grpl { git grep -Il $args }
function grpn { git grep -In $args }
function grup! { grup --prune $args }
function gsh! { gsh --no-prefix $args }
function gshcw! { gsh --color-words --no-prefix $args }
function gshcw.! { gsh --color-words --word-diff-regex=. --no-prefix $args }
function gshcw. { gsh --color-words --word-diff-regex=. $args }
function gshcw { gsh --color-words $args }
function gtags { git fetch --tags; git tag -l --sort=taggerdate $args }
function gum { git cherry -v master $args }
function gws { git rebase --whitespace=strip $args }

function g { git $args }

function ga { git add $args }
function gaa { git add --all $args }
function gapa { git add --patch $args }
function gau { git add --update $args }
function gav { git add --verbose $args }
function gap { git apply $args }
function gapt { git apply --3way $args }

function gb { git branch $args }
function gba { git branch -a $args }
function gbd { git branch -d $args }
#function gbda { git branch --no-color --merged | command grep -vE "^(\+|\*|\s*($(git_main_branch)|development|develop|devel|dev)\s*$)" | command xargs -n 1 git branch -d $args }
function gbD { git branch -D $args }
function gbl { git blame -b -w $args }
function gbnm { git branch --no-merged $args }
function gbr { git branch --remote $args }
function gbs { git bisect $args }
function gbsb { git bisect bad $args }
function gbsg { git bisect good $args }
function gbsr { git bisect reset $args }
function gbss { git bisect start $args }

function gc { git commit -v $args }
function gc! { git commit -v --amend $args }
function gcn! { git commit -v --no-edit --amend $args }
function gca { git commit -v -a $args }
function gca! { git commit -v -a --amend $args }
function gcan! { git commit -v -a --no-edit --amend $args }
function gcans! { git commit -v -a -s --no-edit --amend $args }
function gcam { git commit -a -m $args }
function gcsm { git commit -s -m $args }
function gcb { git checkout -b $args }
function gcf { git config --list $args }
function gcl { git clone --recurse-submodules $args }
function gclean { git clean -id $args }
function gpristine { git reset --hard; git clean -dffx $args }
#function gcm { git checkout $(git_main_branch) $args }
function gcd { git checkout develop $args }
function gcmsg { git commit -m $args }
function gco { git checkout $args }
function gcount { git shortlog -sn $args }
function gcp { git cherry-pick $args }
function gcpa { git cherry-pick --abort $args }
function gcpc { git cherry-pick --continue $args }
function gcs { git commit -S $args }

function gd { git diff $args }
function gdca { git diff --cached $args }
function gdcw { git diff --cached --word-diff $args }
#function gdct { git describe --tags $(git rev-list --tags --max-count=1) $args }
function gds { git diff --staged $args }
function gdt { git diff-tree --no-commit-id --name-only -r $args }
function gdw { git diff --word-diff $args }

function gdv { git diff -w $args | view -; }

function gf { git fetch $args }
function gfa { git fetch --all --prune --jobs=10 $args }
function gfo { git fetch origin $args }

function gfg { git ls-files | grep $args }

function gg { git gui citool $args }
function gga { git gui citool --amend $args }

function ggpur { ggu $args }
function ggpull { git pull origin "$(git_current_branch)" $args }
function ggpush { git push origin "$(git_current_branch)" $args }

function ggsup { git branch --set-upstream-to=origin/$(git_current_branch) $args }
function gpsup { git push --set-upstream origin $(git_current_branch) $args }

function ghh { git help $args }

function gignore { git update-index --assume-unchanged $args }
function gignored { git ls-files -v | grep "^[[:lower:]]" $args }
#function git-svn-dcommit-push { git svn dcommit && git push github $(git_main_branch):svntrunk $args }

function gk { \gitk --all --branches $args }
#function gke { \gitk --all $(git log -g --pretty=%h) $args }

function gl { git pull $args }
function glg { git log --stat $args }
function glgp { git log --stat -p $args }
function glgg { git log --graph $args }
function glgga { git log --graph --decorate --all $args }
function glgm { git log --graph --max-count=10 $args }
function glo { git log --oneline --decorate $args }
function glol { git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' $args }
function glols { git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --stat $args }
function glod { git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset' $args }
function glods { git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset' --date=short $args }
function glola { git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --all $args }
function glog { git log --oneline --decorate --graph $args }
function gloga { git log --oneline --decorate --graph --all $args }
function glp { _git_log_prettily $args }

function gm { git merge $args }
#function gmom { git merge origin/$(git_main_branch) $args }
function gmt { git mergetool --no-prompt $args }
function gmtvim { git mergetool --no-prompt --tool=vimdiff $args }
#function gmum { git merge upstream/$(git_main_branch) $args }
function gma { git merge --abort $args }

function gp { git push $args }
function gpd { git push --dry-run $args }
function gpf { git push --force-with-lease $args }
function gpf! { git push --force $args }
function gpoat { git push origin --all; git push origin --tags $args }
function gpu { git push upstream $args }
function gpv { git push -v $args }

function gr { git remote $args }
function gra { git remote add $args }
function grb { git rebase $args }
function grba { git rebase --abort $args }
function grbc { git rebase --continue $args }
function grbd { git rebase develop $args }
function grbi { git rebase -i $args }
#function grbm { git rebase $(git_main_branch) $args }
function grbo { git rebase --onto $args }
function grbs { git rebase --skip $args }
function grev { git revert $args }
function grh { git reset $args }
function grhh { git reset --hard $args }
#function groh { git reset origin/$(git_current_branch) --hard $args }
function grm { git rm $args }
function grmc { git rm --cached $args }
function grmv { git remote rename $args }
function grrm { git remote remove $args }
function grs { git restore $args }
function grset { git remote set-url $args }
function grss { git restore --source $args }
function grst { git restore --staged $args }
#function grt { cd "$(git rev-parse --show-toplevel || echo .)" $args }
function gru { git reset -- $args }
function grup { git remote update $args }
function grv { git remote -v $args }

function gsb { git status -sb $args }
function gsd { git svn dcommit $args }
function gsh { git show $args }
function gsi { git submodule init $args }
function gsps { git show --pretty=short --show-signature $args }
function gsr { git svn rebase $args }
function gss { git status -s $args }
function gst { git status $args }
function gsta { git stash push $args }
function gstaa { git stash apply $args }
function gstc { git stash clear $args }
function gstd { git stash drop $args }
function gstl { git stash list $args }
function gstp { git stash pop $args }
function gsts { git stash show --text $args }
function gstu { git stash --include-untracked $args }
function gstall { git stash --all $args }
function gsu { git submodule update $args }
function gsw { git switch $args }
function gswc { git switch -c $args }

function gts { git tag -s $args }
function gtv { git tag | sort -V $args }
#function gtl { gtl(){ git tag --sort=-v:refname -n -l "${1}*" }; noglob gtl $args }

function gunignore { git update-index --no-assume-unchanged $args }
function gunwip { git log -n 1 | grep -q -c "\-\-wip\-\-"; git reset HEAD~1 $args }
function gup { git pull --rebase $args }
function gupv { git pull --rebase -v $args }
function gupa { git pull --rebase --autostash $args }
function gupav { git pull --rebase --autostash -v $args }
#function glum { git pull upstream $(git_main_branch) $args }

function gwch { git whatchanged -p --abbrev-commit --pretty=medium $args }
#function gwip { git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign -m "--wip-- [skip ci]" $args }

function gam { git am $args }
function gamc { git am --continue $args }
function gams { git am --skip $args }
function gama { git am --abort $args }
function gamscp { git am --show-current-patch $args }

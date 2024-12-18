@echo off

rem # Shell configuration for Windows Command Prompt.
rem # Source it by running it. Or you can make it autorun
rem # using the registry, if that's your thing, using the key:
rem #
rem #   HKEY_LOCAL_MACHINE\Software\Microsoft\Command Processor\AutoRun
rem #
rem # or:
rem #
rem #   HKEY_CURRENT_USER\Software\Microsoft\Command Processor\AutoRun

set DOTFILES=%~dp0%
set PATH=%PATH%;%DOTFILES%\cmd

doskey ls=dir $*
doskey grep=find $*
doskey less=more $*
doskey cat=type $*
doskey gocfg=cd %DOTFILES%
doskey up=cd ..
doskey up2=cd ..\..
doskey up3=cd ..\..\..
doskey up4=cd ..\..\..\..
doskey up5=cd ..\..\..\..\..
doskey up6=cd ..\..\..\..\..\..
doskey up7=cd ..\..\..\..\..\..\..
doskey up8=cd ..\..\..\..\..\..\..\..
doskey up9=cd ..\..\..\..\..\..\..\..\..

rem # -- Git --

rem # alias some common git typos
doskey giot=git $*
doskey goit=git $*
doskey got=git $*
doskey gti=git $*

doskey gs=git status $*

rem # These complement the ones defined by oh-my-zsh's git plugin.

doskey conflicts!=git diff --name-only --diff-filter=U --no-prefix $*
doskey conflicts=git diff --name-only --diff-filter=U $*
doskey gbv=git branch -avv $*
doskey gcpo=git cherry-pick --strategy=recursive --strategy-option=ours $*
doskey gcpt=git cherry-pick --strategy=recursive --strategy-option=theirs $*
doskey gd!=git diff --no-prefix $*
doskey gdbl=git diff-blame $*
doskey gdcw!=git diff --color-words --no-prefix $*
doskey gdcw.!=git diff --color-words --word-diff-regex=. --no-prefix $*
doskey gdcw.=git diff --color-words --word-diff-regex=. $*
doskey gdcw=git diff --color-words $*
doskey gds!=git diff --staged --no-prefix $*
doskey gdscw!=git diff --staged --color-words --no-prefix $*
doskey gdscw.!=git diff --staged --color-words --word-diff-regex=. --no-prefix $*
doskey gdscw.=git diff --staged --color-words --word-diff-regex=. $*
doskey gdscw=git diff --staged --color-words $*
doskey gfat=gfa; git fetch --all --tags $*
doskey gfb=git filter-branch -f --prune-empty $*
doskey gfbi=git filter-branch -f --prune-empty --index-filter $*
doskey gfbs=git filter-branch -f --prune-empty --subdirectory-filter $*
doskey gfbt=git filter-branch -f --prune-empty --tree-filter $*
doskey gff=git merge --ff --ff-only "HEAD@{u}" $*
doskey gffs=git stash; gff; gpop $*
doskey glns=git log --name-status $*
doskey glnsf=git log --name-status --follow $*
doskey gls=git ls-files $*
doskey gmv=git mv $*
doskey gpack=git reflog expire --expire=now --all; git gc --aggressive --prune=now $*
rem #doskey gpop!=git checkout "stash^{tree}" -- .; git stash drop $*
doskey gpop=git stash pop --index $*
doskey gps=git push $*
doskey grhup=git reset --hard "HEAD@{u}" $*
rem #doskey grim=gri $(git show-ref -q --verify refs/heads/main && echo main || echo master) $*
doskey grp=git grep -I $*
doskey grpi=git grep -Ii $*
doskey grpil=git grep -Iil $*
doskey grpin=git grep -Iin $*
doskey grpl=git grep -Il $*
doskey grpn=git grep -In $*
doskey grup!=git remote update --prune $*
doskey gsh!=gsh --no-prefix $*
doskey gshcw!=gsh --color-words --no-prefix $*
doskey gshcw.!=gsh --color-words --word-diff-regex=. --no-prefix $*
doskey gshcw.=gsh --color-words --word-diff-regex=. $*
doskey gshcw=gsh --color-words $*
doskey gtags=git fetch --tags; git tag -l --sort=taggerdate $*
doskey gum=git cherry -v master $*
doskey gws=git rebase --whitespace=strip $*

doskey g=git $*

doskey ga=git add $*
doskey gaa=git add --all $*
doskey gapa=git add --patch $*
doskey gau=git add --update $*
doskey gav=git add --verbose $*
doskey gap=git apply $*
doskey gapt=git apply --3way $*

doskey gb=git branch $*
doskey gba=git branch -a $*
doskey gbd=git branch -d $*
rem #doskey gbda=git branch --no-color --merged | command grep -vE "^(\+|\*|\s*($(git_main_branch)|development|develop|devel|dev)\s*$)" | command xargs -n 1 git branch -d $*
doskey gbD=git branch -D $*
doskey gbl=git blame -b -w $*
doskey gbnm=git branch --no-merged $*
doskey gbr=git branch --remote $*
doskey gbs=git bisect $*
doskey gbsb=git bisect bad $*
doskey gbsg=git bisect good $*
doskey gbsr=git bisect reset $*
doskey gbss=git bisect start $*

doskey gc=git commit -v $*
doskey gc!=git commit -v --amend $*
doskey gcn!=git commit -v --no-edit --amend $*
doskey gca=git commit -v -a $*
doskey gca!=git commit -v -a --amend $*
doskey gcan!=git commit -v -a --no-edit --amend $*
doskey gcans!=git commit -v -a -s --no-edit --amend $*
doskey gcam=git commit -a -m $*
doskey gcsm=git commit -s -m $*
doskey gcb=git checkout -b $*
doskey gcf=git config --list $*
doskey gcl=git clone --recurse-submodules $*
doskey gclean=git clean -id $*
doskey gpristine=git reset --hard; git clean -dffx $*
rem #doskey gcm=git checkout $(git_main_branch) $*
doskey gcd=git checkout develop $*
doskey gcmsg=git commit -m $*
doskey gco=git checkout $*
doskey gcount=git shortlog -sn $*
doskey gcp=git cherry-pick $*
doskey gcpa=git cherry-pick --abort $*
doskey gcpc=git cherry-pick --continue $*
doskey gcs=git commit -S $*

doskey gd=git diff $*
doskey gdca=git diff --cached $*
doskey gdcw=git diff --cached --word-diff $*
rem #doskey gdct=git describe --tags $(git rev-list --tags --max-count=1) $*
doskey gds=git diff --staged $*
doskey gdt=git diff-tree --no-commit-id --name-only -r $*
doskey gdw=git diff --word-diff $*

doskey gdv=git diff -w $*

doskey gf=git fetch $*
doskey gfa=git fetch --all --prune --jobs=10 $*
doskey gfo=git fetch origin $*

rem #doskey gfg=git ls-files | grep $*

doskey gg=git gui citool $*
doskey gga=git gui citool --amend $*

doskey ggpur=ggu $*
rem #doskey ggpull=git pull origin "$(git_current_branch)" $*
rem #doskey gpush=git push origin "$(git_current_branch)" $*

rem #doskey ggsup=git branch --set-upstream-to=origin/$(git_current_branch) $*
rem #doskey gpsup=git push --set-upstream origin $(git_current_branch) $*

doskey ghh=git help $*

doskey gignore=git update-index --assume-unchanged $*
rem #doskey gignored=git ls-files -v | grep "^[[:lower:]]" $*
rem #doskey git-svn-dcommit-push=git svn dcommit && git push github $(git_main_branch):svntrunk $*

rem #doskey gk=\gitk --all --branches $*
rem #doskey gke=\gitk --all $(git log -g --pretty=%h) $*

doskey gl=git pull $*
doskey glg=git log --stat $*
doskey glgp=git log --stat -p $*
doskey glgg=git log --graph $*
doskey glgga=git log --graph --decorate --all $*
doskey glgm=git log --graph --max-count=10 $*
doskey glo=git log --oneline --decorate $*
doskey glol=git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" $*
doskey glols=git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --stat $*
doskey glod=git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset" $*
doskey glods=git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset" --date=short $*
doskey glola=git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --all $*
doskey glog=git log --oneline --decorate --graph $*
doskey gloga=git log --oneline --decorate --graph --all $*
doskey glp=_git_log_prettily $*

doskey gm=git merge $*
doskey gmom=git merge origin/$(git_main_branch) $*
doskey gmt=git mergetool --no-prompt $*
doskey gmtvim=git mergetool --no-prompt --tool=vimdiff $*
rem #doskey gmum=git merge upstream/$(git_main_branch) $*
doskey gma=git merge --abort $*

doskey gp=git push $*
doskey gpd=git push --dry-run $*
doskey gpf=git push --force-with-lease $*
doskey gpf!=git push --force $*
doskey gpoat=git push origin --all; git push origin --tags $*
doskey gpu=git push upstream $*
doskey gpv=git push -v $*

doskey gr=git remote $*
doskey gra=git remote add $*
doskey grb=git rebase $*
doskey grba=git rebase --abort $*
doskey grbc=git rebase --continue $*
doskey grbd=git rebase develop $*
doskey grbi=git rebase -i $*
rem #doskey grbm=git rebase $(git_main_branch) $*
doskey grbo=git rebase --onto $*
doskey grbs=git rebase --skip $*
doskey grev=git revert $*
doskey grh=git reset $*
doskey grhh=git reset --hard $*
rem #doskey groh=git reset origin/$(git_current_branch) --hard $*
doskey grm=git rm $*
doskey grmc=git rm --cached $*
doskey grmv=git remote rename $*
doskey grrm=git remote remove $*
doskey grs=git restore $*
doskey grset=git remote set-url $*
doskey grss=git restore --source $*
doskey grst=git restore --staged $*
rem #doskey grt=cd "$(git rev-parse --show-toplevel || echo .)" $*
doskey gru=git reset -- $*
doskey grup=git remote update $*
doskey grv=git remote -v $*

doskey gsb=git status -sb $*
doskey gsd=git svn dcommit $*
doskey gsh=git show $*
doskey gsi=git submodule init $*
doskey gsps=git show --pretty=short --show-signature $*
doskey gsr=git svn rebase $*
doskey gss=git status -s $*
doskey gst=git status $*
doskey gsta=git stash push $*
doskey gstaa=git stash apply $*
doskey gstc=git stash clear $*
doskey gstd=git stash drop $*
doskey gstl=git stash list $*
doskey gstp=git stash pop $*
doskey gsts=git stash show --text $*
doskey gstu=git stash --include-untracked $*
doskey gstall=git stash --all $*
doskey gsu=git submodule update $*
doskey gsw=git switch $*
doskey gswc=git switch -c $*

doskey gts=git tag -s $*
rem #doskey gtv=git tag | sort -V $*
rem #doskey gtl=gtl(){ git tag --sort=-v:refname -n -l "${1}*" }; noglob gtl $*

doskey gunignore=git update-index --no-assume-unchanged $*
rem #doskey gunwip=git log -n 1 | grep -q -c "\-\-wip\-\-"; git reset HEAD~1 $*
doskey gup=git pull --rebase $*
doskey gupv=git pull --rebase -v $*
doskey gupa=git pull --rebase --autostash $*
doskey gupav=git pull --rebase --autostash -v $*
rem #doskey glum=git pull upstream $(git_main_branch) $*

doskey gwch=git whatchanged -p --abbrev-commit --pretty=medium $*
rem #doskey gwip=git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign -m "--wip-- [skip ci]" $*

doskey gam=git am $*
doskey gamc=git am --continue $*
doskey gams=git am --skip $*
doskey gama=git am --abort $*
doskey gamscp=git am --show-current-patch $*

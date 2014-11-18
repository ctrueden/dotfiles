# ~/.bashrc

# if not running interactively, don't do anything
[ -z "$PS1" ] && return

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
	debian_chroot=$(cat /etc/debian_chroot)
fi

# path to Homebrew (if installed)
export BREW="/usr/local"

# --== bash completion ==--

if [ -f /etc/bash_completion ]; then
	# Ubuntu Linux
	. /etc/bash_completion

	# NB: Workaround for environment variable expansion bug in bash 4.2+.
	# See: http://askubuntu.com/q/41891
	if ((BASH_VERSINFO[0] >= 4)) && \
		((BASH_VERSINFO[1] >= 2)) && \
		((BASH_VERSINFO[2] >= 29))
	then
		shopt -s direxpand
	fi
fi
if [ -f "$BREW/etc/bash_completion" ]; then
	# Mac OS X with Homebrew ("brew install bash-completion")
	. "$BREW/etc/bash_completion"
fi

# --== git ==--

# enable bash completion of git commands
if [ -f /etc/bash_completion.d/git-prompt ]; then
	# newer Ubuntu Linux ("sudo aptitude install bash-completion")
	. /etc/bash_completion.d/git-prompt # in case of no /etc/bash_completion
	export GIT_COMPLETION=1
elif [ -f /etc/bash_completion.d/git ]; then
	# older Ubuntu Linux ("sudo aptitude install bash-completion")
	. /etc/bash_completion.d/git # in case of no /etc/bash_completion
	export GIT_COMPLETION=1
fi
if [ -f "$BREW/etc/bash_completion.d/git-completion.bash" ]; then
	# Mac OS X with Homebrew ("brew install git bash-completion")
	export GIT_COMPLETION=1
fi

# alias some common git typos
alias giot='git'
alias goit='git'
alias got='git'
alias gti='git'

# --== myrepos ==--

alias mr='mr --stats'

# --== shell prompt ==--

SHELL_PROMPT=': ${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@${HOSTNAME}\[\033[00m\] \[\033[01;34m\]\w'

if [ "$GIT_COMPLETION" ]; then
	# make shell prompt reflect current git status+branch
	PS1="$SHELL_PROMPT"'\[\033[01;32m\]$(__git_ps1)\[\033[00m\]\n'
else
	PS1="$SHELL_PROMPT"'\[\033[00m\]\n'
fi

# --== xterm ==--

alias xterm='xterm -geometry 80x60 -fg white -bg black'
# update terminal title as appropriate
case "$TERM" in
	xterm*|rxvt*)
		PROMPT_COMMAND='
			if [ -n "$TERM_TITLE" ]
			then
				echo -ne "\033]0;$TERM_TITLE\007"
			else
				echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"
			fi
		'
		;;
	*)
		;;
esac

# --== operating system (Darwin, Linux, etc.) ==--

export OS_NAME="$(uname)"
if [ "$OS_NAME" == "Darwin" ]; then
	export IS_MACOSX=1
elif [ "$OS_NAME" == "Linux" ]; then
	export IS_LINUX=1
elif [ "${OS_NAME:0:6}" == 'CYGWIN' ]; then
	export IS_WINDOWS=1
fi

# --== CVS/SVN ==--

export CVS_RSH=ssh

# use vim to edit commit messages
export EDITOR=vim
export VISUAL="$EDITOR"

# do not autocomplete .svn folders
export FIGNORE=.svn

# --== bash ==--

# use vi commands for advanced editing (hit ESC to enter command mode)
set -o vi

# --== useful commands ==--

# jump to the folder containing the searched-for argument
goto() { cd "$(dirname "$(echo "$(wi "$@")" | head -n 1)")"; }

# change the title of the current xterm
tt() { TERM_TITLE="$@"; }

# --== Maven ==--

export MAVEN_OPTS="-Xmx1536m -XX:MaxPermSize=256m"

# --== source code directories ==--

# base directory for all projects
export PATH_CODE="$HOME/code"

# personal projects - https://github.com/ctrueden
export PATH_PERSONAL="$PATH_CODE/ctrueden"
alias goctr='cd $PATH_PERSONAL'

# configuration files
export PATH_CONFIG="$PATH_PERSONAL/ctr-config"
alias gocfg='cd $PATH_CONFIG'
export PATH_CFG_PRIVATE="$PATH_PERSONAL/ctr-cfg-private"
alias gocfp='cd $PATH_CFG_PRIVATE'

# useful scripts
export PATH_SCRIPTS="$PATH_PERSONAL/ctr-scripts"
alias gosc='cd $PATH_SCRIPTS'

# private projects
export PATH_PRIVATE="$PATH_PERSONAL/ctr-private"
alias gop='cd $PATH_PRIVATE'

# LOCI projects - https://github.com/uw-loci
export PATH_LOCI="$PATH_CODE/loci"
alias go='cd $PATH_LOCI'
alias goj2l='cd $PATH_LOCI/jar2lib/src/main/resources'
alias gov='cd $PATH_LOCI/visbio/src/main/java/loci/visbio'
alias gow='cd $PATH_LOCI/wiscscan'

# SCIFIO - https://github.com/scifio
export PATH_SCIFIO="$PATH_CODE/scifio/scifio"
alias gos='cd $PATH_SCIFIO'
alias gops='cd $PATH_SCIFIO/../pom-scifio'
alias goscli='cd $PATH_SCIFIO/../scifio-cli'
alias goso='cd $PATH_SCIFIO/../scifio-omero'
alias gost='cd $PATH_SCIFIO/../scifio-tutorials'

# Bio-Formats - https://github.com/openmicroscopy/bioformats
export PATH_BF4="$PATH_CODE/ome/bf4"
alias gobf4='cd $PATH_BF4'
alias gobf4a='cd $PATH_BF4/components/autogen/src'
alias gobf4c='cd $PATH_BF4/components/common/src/loci/common'
alias gobf4f='cd $PATH_BF4/components/bio-formats/src/loci/formats'
alias gobf4p='cd $PATH_BF4/components/loci-plugins/src/loci/plugins'
alias gobf4x='cd $PATH_BF4/components/ome-xml/src/ome/xml'
export PATH_BF5="$PATH_CODE/ome/bf5"
alias gobf5='cd $PATH_BF5'
alias gobf5a='cd $PATH_BF5/components/autogen/src'
alias gobf5c='cd $PATH_BF5/components/formats-common/src/loci/common'
alias gobf5f='cd $PATH_BF5/components/formats-api/src/loci/formats'
alias gobf5p='cd $PATH_BF5/components/bio-formats-plugins/src/loci/plugins'
alias gobf5x='cd $PATH_BF5/components/ome-xml/src/ome/xml'
export PATH_BF="$PATH_CODE/ome/bf-develop"
alias gobf='cd $PATH_BF'
alias gobfa='cd $PATH_BF/components/autogen/src'
alias gobfc='cd $PATH_BF/components/formats-common/src/loci/common'
alias gobff='cd $PATH_BF/components/formats-api/src/loci/formats'
alias gobfp='cd $PATH_BF/components/bio-formats-plugins/src/loci/plugins'
alias gobfx='cd $PATH_BF/components/ome-xml/src/ome/xml'
export PATH="$PATH_BF5/tools:$PATH"

# ImageJ - https://github.com/imagej
export PATH_IJ="$PATH_CODE/imagej/imagej"
alias goij='cd $PATH_IJ'
alias goij1='cd $PATH_IJ/../ImageJA'
alias goij1p='cd $PATH_IJ/../ij1-patcher'
alias goij1t='cd $PATH_IJ/../ij1-tests'
alias goijc='cd $PATH_IJ/../imagej-common'
alias goijla='cd $PATH_IJ/../imagej-launcher'
alias goijle='cd $PATH_IJ/../imagej-legacy'
alias goijl='goijle'
alias goijo='cd $PATH_IJ/../imagej-omero'
alias goijs='cd $PATH_IJ/../imagej-server'
alias goijt='cd $PATH_IJ/../imagej-tutorials'
alias goijup='cd $PATH_IJ/../imagej-updater'
alias goijus='cd $PATH_IJ/../imagej-usage'
alias goiju='goijup'
alias gopij='cd $PATH_IJ/../pom-imagej'

# ImageJ OPS - https://github.com/imagej/imagej-ops
export PATH_OPS="$PATH_IJ/../imagej-ops"
alias goops='cd $PATH_OPS'

# ImgLib2 - https://github.com/imglib/imglib2
export PATH_IMGLIB="$PATH_CODE/imglib/imglib2"
alias goil='cd $PATH_IMGLIB'
alias goila='cd $PATH_IMGLIB/../imglib2-algorithm'
alias goilaf='cd $PATH_IMGLIB/../imglib2-algorithm-fft'
alias goilag='cd $PATH_IMGLIB/../imglib2-algorithm-gpl'
alias goilij='cd $PATH_IMGLIB/../imglib2-ij'
alias goilr='goilroi'
alias goilrt='cd $PATH_IMGLIB/../imglib2-realtransform'
alias goilroi='cd $PATH_IMGLIB/../imglib2-roi'
alias goils='cd $PATH_IMGLIB/../imglib2-script'
alias goilt='goilte'
alias goilte='cd $PATH_IMGLIB/../imglib2-tests'
alias goiltu='cd $PATH_IMGLIB/../imglib2-tutorials'
alias gopil='cd $PATH_IMGLIB/../pom-imglib2'

# ITK - https://github.com/Kitware/ITK
export PATH_ITK="$HOME/code/kitware/ITK"
alias goitk='cd $PATH_ITK'

# Fiji - https://github.com/fiji
export PATH_FIJI="$PATH_CODE/fiji/fiji"
alias gofi='cd $PATH_FIJI'
alias gopf='cd $PATH_FIJI/../pom-fiji'
alias gotm='cd $PATH_FIJI/../TrackMate'
alias gocb='cd $PATH_FIJI/../cookbook'

# BigDataViewer - https://github.com/bigdataviewer
export PATH_BDV="$PATH_CODE/bdv"
alias gobdv='cd $PATH_BDV'

# JEX
export PATH_JEX="$PATH_CODE/other/jex"
alias gojex='cd $PATH_JEX'

# SciJava - https://github.com/scijava
export PATH_SCIJAVA="$PATH_CODE/scijava"
alias gopsj='cd $PATH_SCIJAVA/pom-scijava'
alias gosjc='cd $PATH_SCIJAVA/scijava-common'
alias gosjs='cd $PATH_SCIJAVA/scijava-scripts'

# Git - https://github.com/git/git
export PATH_GIT="$PATH_CODE/git/git"
alias gogit='cd $PATH_GIT'

# NAR - https://github.com/maven-nar/nar-maven-plugin
export PATH_NAR="$PATH_CODE/nar/nar-maven-plugin"
alias gonar='cd $PATH_NAR'

# CellProfiler - https://github.com/CellProfiler/CellProfiler
export PATH_CELLPROFILER="$PATH_CODE/cellprofiler/CellProfiler"
alias gocp='cd $PATH_CELLPROFILER'

# SLIM Curve - https://github.com/slim-curve
export PATH_SLIM="$PATH_CODE/slim"
alias goslim='cd $PATH_SLIM'

# VisAD
export PATH_VISAD="$PATH_CODE/other/visad"

# -- image data directories --

export DATA="$HOME/share/data"
alias god='cd $HOME/data'

# --== OMERO ==--

export PATH_OMERO="$PATH_CODE/ome/openmicroscopy"
export PATH_OMERO_DIST="$PATH_OMERO/dist"
if [ -d "$PATH_OMERO_DIST" ]
then
	export OMERO_PREFIX="$PATH_OMERO_DIST"
else
	export OMERO_PREFIX="$(find "$HOME/apps" -name 'OMERO.server*' -type d 2> /dev/null)"
fi
export ICE_CONFIG="$OMERO_PREFIX/etc/ice.config"
if [ "$IS_LINUX" ]; then
	export ICE_HOME=/usr/share/Ice-3.4.2
	export POSTGRES_HOME=/usr/lib/postgresql/9.1
	export PYTHONPATH=/usr/lib/pymodules/python2.7:$PYTHONPATH
	export LD_LIBRARY_PATH=/usr/share/java:/usr/lib:$LD_LIBRARY_PATH
elif [ "$IS_MACOSX" ]; then
	export ICE_HOME="$(brew --prefix ice)"
	export SLICEPATH="$ICE_HOME/share/Ice-3.5/slice"
	export PYTHONPATH="$OMERO_PREFIX/lib/python:/usr/local/lib/python2.7/site-packages"
fi
export PATH="$OMERO_PREFIX/bin:$PATH"
alias goome='cd "$OMERO_PREFIX"'
alias fix-omero='omero admin ice "server stop Processor-0"'

# --== path ==--

export PATH=\
$HOME/bin:\
$PATH_SCRIPTS:\
$PATH_SCIJAVA/scijava-scripts:\
$PATH_FIJI/bin:\
$PATH

# prepend Homebrew bin directories to the path, if applicable
if [ -d "$BREW/bin" ]; then
	export PATH="$BREW/bin:$BREW/sbin:$PATH"
fi

# --== Java ==--

# set locations of Java
if [ "$IS_MACOSX" ]; then
  jvmdir=/Library/Java/JavaVirtualMachines
	export J6="$( \
		find $jvmdir -mindepth 1 -maxdepth 1 | \
		grep '1.6' |\
		sort -r |\
		head -n 1)/Contents/Home"
	export J7="$( \
		find $jvmdir -mindepth 1 -maxdepth 1 |\
		grep '1.7' |\
		sort -r |\
		head -n 1)/Contents/Home"
	export J8="$( \
		find $jvmdir -mindepth 1 -maxdepth 1 |\
		grep '1.8' |\
		sort -r |\
		head -n 1)/Contents/Home"
fi
alias j6='export JAVA_HOME=$J6 && echo "JAVA_HOME -> $JAVA_HOME" && java -version'
alias j7='export JAVA_HOME=$J7 && echo "JAVA_HOME -> $JAVA_HOME" && java -version'
alias j8='export JAVA_HOME=$J8 && echo "JAVA_HOME -> $JAVA_HOME" && java -version'

# unset the actual classpath, since some programs play badly with it
unset CLASSPATH

# add some basic directories to the classpath
export JAVA_CP=\
$HOME/java:\
$PATH_PRIVATE/java:\
$PATH_PRIVATE/java/utils

# generate classpath for desired Maven artifacts
cpFile="$HOME/.java-classpath"
if [ ! -e "$cpFile" ]; then
	# generate classpath cache
	echo "Regenerating $cpFile"
	maven-cp \
		ome:formats-gpl:5.0.5 \
		loci:loci-utils:1.0.0-SNAPSHOT \
		org.beanshell:bsh:2.0b4 > $cpFile
fi
export JAVA_CP="$JAVA_CP:$(cat $cpFile)"

# add Bio-Formats utils folders to the classpath
for dir in $PATH_BF/components/*/utils
do
	export JAVA_CP="$JAVA_CP:$dir"
done

# add aliases for launching Java with the JAVA_CP classpath
alias j='java -cp $JAVA_CP:.'
alias jc='javac -cp $JAVA_CP:.'

# --== ls ==--

# use readable ls colors
if [ "$IS_LINUX" ]; then
	alias ls='ls -AF --color=auto'
	export LS_COLORS="ow=30;42"
else
	alias ls='ls -AFG'
fi
if [ "$IS_MACOSX" ]; then
	export LSCOLORS="ExGxBxDxCxEgedabagacad"
fi

# --== diff ==--

# use git for superior diff formatting
alias diff='git diff --no-index'

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

# --== hub (http://hub.github.com/) ==--

command -v hub >/dev/null 2>&1 && \
	alias git='hub'

# --== git-svn ==--

# tell git-svn where to find SVN authors
SVN_AUTHORS="$PATH_CFG_PRIVATE/authors.txt"

# --== Git-Mediawiki (https://github.com/moy/Git-Mediawiki/wiki) ==--

# Install prerequisites:
# cpan MediaWiki::API
# cpan DateTime::Format::ISO8601

# Put git-remote-mediawiki and git-mw somewhere on your PATH:
# ln -s "$PATH_GIT/contrib/mw-to-git/git-remote-mediawiki.perl" \
#       ~/bin/git-remote-mediawiki
# ln -s "$PATH_GIT/contrib/mw-to-git/git-mw" ~/bin

export PERL5LIB="$PATH_GIT/perl:$PATH_GIT/contrib/mw-to-git"

# --== Python sphinx ==--

# fail the sphinx build when there are warnings
export SPHINXOPTS=-W

# --== email ==--

# viq - format the clipboard as an email quote
alias viq="vi \
	+'set tw=72' \
	+'normal! \"+p' \
	+':silent :1g/^$/d' \
	+':silent :g/^/s//> /' \
	+'normal! 1GVGgq1G\"+yG'"

# --== vim ==--

alias vi='vim'

# --== shell ==--

alias mv='mv -i'
alias cls='clear;pwd;ls'
alias cdiff='colordiff 2> /dev/null'
alias grep='grep --color=auto'
alias cgrep='grep --color=always'
alias rgrep='grep -IR --exclude="*\.svn*"'
alias f='find . -name'

# --== start ==--

# open a UI browser for the specified folder using 'start'
if [ "$IS_MACOSX" ]; then
	alias start='open'
elif [ "$IS_LINUX" ]; then
	alias start='nautilus'
elif [ "$IS_WINDOWS" ]; then
	alias start='cmd /c start'
fi

# --== version reporting ==--

# report details of the OS using 'ver'
if [ "$IS_MACOSX" ]; then
	alias version='sw_vers'
elif [ "$IS_WINDOWS" ]; then
	alias version='ver'
else
	alias version='if [ -e /proc/version ]; then cat /proc/version; fi; if which lsb_release > /dev/null 2>&1; then lsb_release -a; fi; if [ -e /etc/redhat-release ]; then cat /etc/redhat-release; fi'
fi

# --== history ==--

alias histime='HISTTIMEFORMAT="%F %T " history'

# --== eject ==--

if [ "$IS_MACOSX" ]; then
  alias eject='diskutil eject'
fi

# --== ldd ==--

if [ ! -x "$(which ldd)" ]; then
	# make 'ldd' work on OS X
	alias ldd='otool -L'
fi

# --== hex editor ==--

# open a graphical hex editor using 'hex'
if [ "$IS_MACOSX" ]; then
	alias hex='/Applications/Hex\ Fiend.app/Contents/MacOS/Hex\ Fiend'
else
	alias hex='ghex2'
fi

# --== Fiji ==--

# launch Fiji with 'fiji'
if [ "$IS_MACOSX" ]; then
	export PATH_FIJI_USER="/Applications/Science/Fiji.app"
	export FIJI_EXEC="$PATH_FIJI_USER/Contents/MacOS/ImageJ-macosx"
elif [ "$IS_WINDOWS" ]; then
	export PATH_FIJI_USER="$HOME/Applications/Fiji.app"
	export FIJI_EXEC="$PATH_FIJI_USER/ImageJ-win64"
else
	export PATH_FIJI_USER="$HOME/Applications/Fiji.app"
	export FIJI_EXEC="$PATH_FIJI_USER/ImageJ-linux64"
fi
alias fiji='$FIJI_EXEC'
alias fiji6='$FIJI_EXEC --java-home "$J6"'
alias fiji7='$FIJI_EXEC --java-home "$J7"'
alias fiji8='$FIJI_EXEC --java-home "$J8"'

# --== Maven ==--

# launch Maven 2.x with 'mvn2'
if [ -d "$BREW/Cellar/maven2" ]; then
	alias mvn2="$BREW/Cellar/maven2/2.2.1/bin/mvn"
fi

# license-maven-plugin
alias lic='mvn license:update-project-license license:update-file-header'

# dependency-maven-plugin
alias anal='mvn dependency:analyze | grep WARNING'

# build it!
alias b='mvn clean install'
alias bs='mvn -DskipTests clean install'

# --== sed ==--

# make in-place sed editing consistent across OSes
if [ "$IS_MACOSX" ]; then
	# BSD sed requires a space after -i argument
	alias sedi="sed -i ''"
else
	# GNU sed requires no space after -i argument
	alias sedi="sed -i''"
fi

# --== tab removal ==--

# remove tabs from files using 'detab'
alias detab="sedi -e 's/	/  /g'"

# --== LOCI apps ==--

alias slim='j -mx512m loci.slim.SlimPlotter'
alias visbio='j -mx1024m -Dswing.defaultlaf=com.jgoodies.looks.plastic.Plastic3DLookAndFeel loci.visbio.VisBio'

# --== navigation shortcuts ==--

alias asdf='cd $HOME && clear'
alias up='cd ..'
alias up2='cd ../..'
alias up3='cd ../../..'
alias up4='cd ../../../..'
alias up5='cd ../../../../..'
alias up6='cd ../../../../../..'
alias up7='cd ../../../../../../..'
alias up8='cd ../../../../../../../..'
alias up9='cd ../../../../../../../../..'
alias upa='cd ../../../../../../../../../..'
alias upb='cd ../../../../../../../../../../..'
alias upc='cd ../../../../../../../../../../../..'
alias upd='cd ../../../../../../../../../../../../..'
alias upe='cd ../../../../../../../../../../../../../..'
alias upf='cd ../../../../../../../../../../../../../../..'

# --== machine shortcuts ==--

alias cyber='ssh cyber'
alias dev='ssh dev'
alias drupal='ssh drupal'
alias ome='ssh ome'
alias sirius='ssh sirius'
alias server='ssh server'
alias skynet='ssh skynet'
alias tera='ssh tera'

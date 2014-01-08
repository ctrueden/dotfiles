# ~/.profile or ~/.bashrc

# On Mac OS X, alias to ~/.profile or ~/.bash_profile.
# On Ubuntu, alias to ~/.bashrc.

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

# tell git-svn where to find SVN authors
SVN_AUTHORS="$CONFIG_DIR/authors.txt"

# alias some common git typos
alias giot='git'
alias goit='git'
alias got='git'
alias gti='git'

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
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
		;;
	*)
		;;
esac

# --== operating system (Darwin, Linux, etc.) ==--

export OS_NAME=`uname`
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

# --== Maven ==--

export MAVEN_OPTS="-Xmx1536m -XX:MaxPermSize=256m"

# --== source code directories ==--

# base directory for all projects
export CODE_DIR="$HOME/code"

# personal projects - https://github.com/ctrueden
export PERSONAL_DIR="$CODE_DIR/ctrueden"
alias goctr='cd $PERSONAL_DIR'

# configuration files
export CONFIG_DIR="$PERSONAL_DIR/ctr-config"
alias gocfg='cd $CONFIG_DIR'

# useful scripts
export SCRIPTS_DIR="$PERSONAL_DIR/ctr-scripts"
alias gosc='cd $SCRIPTS_DIR'

# private projects
export PRIVATE_DIR="$PERSONAL_DIR/ctr-private"
alias gop='cd $PRIVATE_DIR'

# LOCI projects - https://github.com/uw-loci
export LOCI_DIR="$CODE_DIR/loci"
alias go='cd $LOCI_DIR'
alias goj2l='cd $LOCI_DIR/jar2lib/src/main/resources'
alias gov='cd $LOCI_DIR/visbio/src/main/java/loci/visbio'
alias gow='cd $LOCI_DIR/internal/WiscScan'

# SCIFIO - https://github.com/scifio
export SCIFIO_DIR="$CODE_DIR/scifio/scifio"
alias gos='cd $SCIFIO_DIR'
alias goso='cd $SCIFIO_DIR/../scifio-omero'
alias gost='cd $SCIFIO_DIR/../scifio-tutorials'

# Bio-Formats - https://github.com/openmicroscopy/bioformats
export BF_DIR="$CODE_DIR/ome/bioformats"
alias gobf='cd $BF_DIR'
alias gobfa='cd $BF_DIR/components/autogen/src'
alias gobfc='cd $BF_DIR/components/common/src/loci/common'
alias gobff='cd $BF_DIR/components/bio-formats/src/loci/formats'
alias gobfp='cd $BF_DIR/components/loci-plugins/src/loci/plugins'
alias gobfx='cd $BF_DIR/components/ome-xml/src/ome/xml'

# ImageJ - https://github.com/imagej
export IJ_DIR="$CODE_DIR/imagej/imagej"
alias goij='cd $IJ_DIR'
alias goij1='cd $IJ_DIR/../imageja'
alias goijl='cd $IJ_DIR/../imagej-launcher'
alias goijo='cd $IJ_DIR/../imagej-omero'
alias goijs='cd $IJ_DIR/../imagej-server'
alias goijt='cd $IJ_DIR/../imagej-tutorials'

# ImgLib2 - https://github.com/imglib/imglib
export IMGLIB_DIR="$CODE_DIR/imglib/imglib"
alias goil='cd $IMGLIB_DIR'

# ITK - https://github.com/Kitware/ITK
export ITK_DIR="$HOME/code/kitware/ITK"
alias goitk='cd $ITK_DIR'

# Fiji - https://github.com/fiji
export FIJI_DIR="$CODE_DIR/fiji/fiji"
alias gofi='cd $FIJI_DIR'
alias gotm='cd $FIJI_DIR/../TrackMate'
alias gocb='cd $FIJI_DIR/../cookbook'

# SciJava - https://github.com/scijava
export SCIJAVA_DIR="$CODE_DIR/scijava/scijava-common"
alias gosj='cd $SCIJAVA_DIR'

# SciJava OPS - https://github.com/scijava/scijava-ops
export OPS_DIR="$SCIJAVA_DIR/../scijava-ops"
alias goops='cd $OPS_DIR'

# NAR - https://github.com/maven-nar/nar-maven-plugin
export NAR_DIR="$CODE_DIR/nar/nar-maven-plugin"
alias gonar='cd $NAR_DIR'

# CellProfiler - https://github.com/CellProfiler/CellProfiler
export CELLPROFILER_DIR="$CODE_DIR/cellprofiler/CellProfiler"
alias gocp='cd $CELLPROFILER_DIR'

# VisAD
export VISAD_DIR="$CODE_DIR/other/visad"

# -- image data directories --

export DATA="$HOME/share/data"
alias god='cd $HOME/data'

# --== OMERO ==--

export OMERO_DIR="$CODE_DIR/ome/openmicroscopy/dist"
if [ "$IS_LINUX" ]; then
	export ICE_HOME=/usr/share/Ice-3.4.2
	export POSTGRES_HOME=/usr/lib/postgresql/9.1
	export PYTHONPATH=/usr/lib/pymodules/python2.7:$PYTHONPATH
	export LD_LIBRARY_PATH=/usr/share/java:/usr/lib:$LD_LIBRARY_PATH
fi
alias goome='cd $OMERO_DIR'

# --== path ==--

export PATH=\
$HOME/bin:\
$SCRIPTS_DIR:\
$SCIJAVA_DIR/bin:\
$BF_DIR/tools:\
$FIJI_DIR/bin:\
$OMERO_DIR/bin:\
$PATH

# prepend Homebrew bin directories to the path, if applicable
if [ -d "$BREW/bin" ]; then
	export PATH="$BREW/bin:$BREW/sbin:$PATH"
fi

# --== Java ==--

# unset the actual classpath, since some programs play badly with it
unset CLASSPATH

# add some basic directories to the classpath
export JAVA_CP=\
$HOME/java:\
$PRIVATE_DIR/java:\
$PRIVATE_DIR/java/utils

# generate classpath for desired Maven artifacts
cpFile="$HOME/.java-classpath"
if [ ! -e "$cpFile" ]; then
	# generate classpath cache
	echo "Regenerating $cpFile"
	maven-cp \
		loci:bio-formats:4.5-SNAPSHOT \
		loci:utils:1.0.0-SNAPSHOT \
		org.beanshell:bsh:2.0b4 > $cpFile
fi
export JAVA_CP="$JAVA_CP:`cat $cpFile`"

# add Bio-Formats utils folders to the classpath
for dir in $BF_DIR/components/*/utils
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

# --== Python sphinx ==--

# fail the sphinx build when there are warnings
export SPHINXOPTS=-W

# useful functions

where() { find . -name $* | grep -v 'build/'; }
goto() { cd $(dirname $(where $*)); }

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
alias grep='grep --colour=auto'
alias rgrep='grep -IR --exclude="*\.svn*"'
alias f='find . -name'

# --== cygwin ==--

if [ "$IS_WINDOWS" ]; then
	alias clear='cmd /c cls'
fi

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

if [ ! -x "`which ldd`" ]; then
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
	alias fiji='/Applications/Science/Fiji.app/Contents/MacOS/ImageJ-macosx'
elif [ "$IS_WINDOWS" ]; then
	alias fiji='$HOME/Applications/Fiji.app/ImageJ-win64'
else
	alias fiji='$HOME/Applications/Fiji.app/ImageJ-linux64'
fi

# --== Maven ==--

# launch Maven 2.x with 'mvn2'
if [ -d "$BREW/Cellar/maven2" ]; then
	alias mvn2="$BREW/Cellar/maven2/2.2.1/bin/mvn"
fi

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

alias dev='ssh dev'
alias drupal='ssh drupal'
alias ome='ssh ome'
alias rook='ssh rook'
alias server='ssh server'
alias skynet='ssh skynet'
alias tera='ssh tera'

# ~/.profile or ~/.bashrc

# On Mac OS X, alias to ~/.profile or ~/.bash_profile.

# On Ubuntu, alias to ~/.bashrc.

# See /usr/share/doc/bash/examples/startup-files
# (in the package bash-doc) for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
# NB: We use source-highlight below. Should this be disabled?
# http://blog.tersmitten.nl/how-to-enable-syntax-highlighting-in-less.html
# [ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# don't put duplicate lines in the history. See bash(1) for more options
#export HISTCONTROL=ignoredups

export BREW=~/brew

# programmatic completion features
if [ -f /etc/bash_completion ]; then
  # Ubuntu Linux
  . /etc/bash_completion
fi
if [ -f "$BREW/etc/bash_completion" ]; then
  # Mac OS X with Homebrew ("brew install bash-completion")
  . "$BREW/etc/bash_completion"
fi

# color prompt
PS1=': ${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@${HOSTNAME}\[\033[00m\] \[\033[01;34m\]\w\[\033[00m\]\n'

# include git completion
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
if [ "$GIT_COMPLETION" ]; then
  PS1=': ${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@${HOSTNAME}\[\033[00m\] \[\033[01;34m\]\w\[\033[01;32m\]$(__git_ps1)\[\033[00m\]\n'
fi

# setup - xterm
alias xterm='xterm -geometry 80x60 -fg white -bg black'
# update terminal title as appropriate
case "$TERM" in
  xterm*|rxvt*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
    ;;
  *)
    ;;
esac

# setup - operating system (Darwin, Linux, etc.)
export OS_NAME=`uname`
if [ "$OS_NAME" == "Darwin" ]; then
  export IS_MACOSX=1
elif [ "$OS_NAME" == "Linux" ]; then
  export IS_LINUX=1
elif [ "${OS_NAME:0:6}" == 'CYGWIN' ]; then
  export IS_WINDOWS=1
fi

# setup - CVS/SVN
export CVS_RSH=ssh
export EDITOR=vim
export VISUAL="$EDITOR"
alias viq="vi \
  +'set tw=72' \
  +'normal! \"+p' \
  +':silent :1g/^$/d' \
  +':silent :g/^/s//> /' \
  +'normal! 1GVGgq1G\"+yG'"

# setup - bash
# do not autocomplete .svn folders
export FIGNORE=.svn
# use vi commands for advanced editing (hit ESC to enter command mode)
set -o vi

# setup - Maven
export MAVEN_OPTS=-Xmx1536m

# useful dirs
export CODE_DIR=~/code
export CONFIG_DIR="$CODE_DIR/ctrueden/ctr-config"
export SCRIPTS_DIR="$CODE_DIR/ctrueden/ctr-scripts"

export PRIVATE_JAVA="$CODE_DIR/ctrueden/ctr-private/java"
export LOCI_SOFTWARE="$CODE_DIR/loci"
export LOCI_INTERNAL="$LOCI_SOFTWARE/internal"
export SCIFIO_HOME="$CODE_DIR/scifio/scifio"
export BF_HOME="$CODE_DIR/ome/bioformats"
export IJ_HOME="$CODE_DIR/imagej/imagej"
export IMGLIB_HOME="$CODE_DIR/imagej/imglib"
export FIJI_HOME="$CODE_DIR/imagej/fiji"
export SCIJAVA="$CODE_DIR/scijava/scijava-common"
export NAR_HOME="$CODE_DIR/nar/maven-nar-plugin"
export CELLPROFILER_HOME="$CODE_DIR/cellprofiler/CellProfiler"
export VISAD="$CODE_DIR/other/visad"

# setup - OMERO
export ICE_HOME=/usr/share/Ice-3.4.2
export POSTGRES_HOME=/usr/lib/postgresql/9.1
export OMERO_HOME="$CODE_DIR/ome/openmicroscopy/dist"
export PYTHONPATH=/usr/lib/pymodules/python2.7:$PYTHONPATH
export LD_LIBRARY_PATH=/usr/share/java:/usr/lib:$LD_LIBRARY_PATH

# setup - path
export PATH=\
~/bin:\
$SCRIPTS_DIR:\
$SCIJAVA/bin:\
$BF_HOME/tools:\
$FIJI_HOME/bin:\
$OMERO_HOME/bin:\
$PATH

# setup - Java classpath
unset CLASSPATH
export CP=\
~/java:\
$PRIVATE_JAVA:\
$PRIVATE_JAVA/utils

cpFile="$HOME/.java-classpath"
if [ ! -e "$cpFile" ]; then
  # generate classpath cache
  echo "Regenerating $cpFile"
  maven-cp \
    loci:bio-formats:4.5-SNAPSHOT \
    loci:utils:1.0.0-SNAPSHOT \
    org.beanshell:bsh:2.0b4 > $cpFile
fi
export CP="$CP:`cat $cpFile`"

for dir in $BF_HOME/components/*/utils
do
  export CP="$CP:$dir"
done

# setup - Homebrew
if [ -d "$BREW/bin" ]; then
  export PATH="$BREW/bin:$PATH"
fi

# setup - ls
if [ "$IS_LINUX" ]; then
  alias ls='ls -AF --color=auto'
else
  alias ls='ls -AFG'
fi

# setup - diff
alias diff='git diff --no-index'

# setup - git svn
SVN_AUTHORS="$CONFIG_DIR/authors.txt"

# setup - less
export LESS=' -R '
if [ -d /usr/share/source-highlight ]; then
  export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
elif [ -d ~/brew/Cellar/source-highlight ]; then
  export LESSOPEN="| ~/brew/Cellar/source-highlight/*/bin/src-hilite-lesspipe.sh %s"
fi

# setup - xmllint
export XMLLINT_INDENT=$'\t'

# setup - hub (if installed)
command -v hub >/dev/null 2>&1 && \
  alias git='hub'

# setup - ITK
export ITK_HOME=~/code/kitware/ITK

# useful functions
where() { find . -name $* | grep -v 'build/'; }
goto() { cd $(dirname $(where $*)); }

# useful aliases - Java
alias j='java -cp $CP:.'
alias jc='javac -cp $CP:.'

# useful aliases - git
alias giot='git'
alias goit='git'
alias got='git'
alias gti='git'

# useful aliases - vim
alias vi='vim'

# useful aliases - shell
alias mv='mv -i'
alias cls='clear;pwd;ls'
alias cdiff='colordiff 2> /dev/null'
alias grep='grep --colour=auto'
alias rgrep='grep -IR --exclude="*\.svn*"'
alias f='find . -name'

# useful aliases - cygwin
if [ "$IS_WINDOWS" ]; then
  alias clear='cmd /c cls'
fi

# useful aliases - start
if [ "$IS_MACOSX" ]; then
  alias start='open'
elif [ "$IS_LINUX" ]; then
  alias start='nautilus'
elif [ "$IS_WINDOWS" ]; then
  alias start='cmd /c start'
fi

# useful aliases - version
if [ "$IS_MACOSX" ]; then
  alias version='sw_vers'
elif [ "$IS_WINDOWS" ]; then
  alias version='ver'
else
  alias version='if [ -e /proc/version ]; then cat /proc/version; fi; if which lsb_release > /dev/null 2>&1; then lsb_release -a; fi; if [ -e /etc/redhat-release ]; then cat /etc/redhat-release; fi'
fi

# useful aliases - history
alias histime='HISTTIMEFORMAT="%F %T " history'

# useful aliases - ldd
if [ ! -x "`which ldd`" ]; then
  alias ldd='otool -L'
fi

# useful aliases - hex editor
if [ "$IS_MACOSX" ]; then
  alias hex='/Applications/Hex\ Fiend.app/Contents/MacOS/Hex\ Fiend'
else
  alias hex='ghex2'
fi

# useful aliases - Maven
if [ -d "$BREW/Cellar/maven2" ]; then
  alias mvn2="$BREW/Cellar/maven2/2.2.1/bin/mvn"
fi

# useful aliases - remove tabs from source files
if [ "$IS_MACOSX" ]; then
  # BSD sed requires a space after -i argument
  alias detab="sed -i '' -e 's/	/  /g'"
else
  # GNU sed requires no space after -i argument
  alias detab="sed -i'' -e 's/	/  /g'"
fi

# useful aliases - LOCI apps
alias slim='j -mx512m loci.slim.SlimPlotter'
alias visbio='j -mx1024m -Dswing.defaultlaf=com.jgoodies.looks.plastic.Plastic3DLookAndFeel loci.visbio.VisBio'

# useful aliases - navigation
alias asdf='cd ~ && clear'
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
alias go='cd $LOCI_SOFTWARE'
alias goa='cd $BF_HOME/components/autogen/src'
alias gobf='cd $BF_HOME'
alias goc='cd $BF_HOME/components/common/src/loci/common'
alias gocfg='cd $CONFIG_DIR'
alias gocp='cd $CELLPROFILER_HOME'
alias god='cd ~/data'
alias gof='cd $BF_HOME/components/bio-formats/src/loci/formats'
alias gofi='cd $FIJI_HOME'
alias goij='cd $IJ_HOME'
alias goij1='cd $IJ_HOME/../imageja'
alias goijl='cd $IJ_HOME/../imagej-launcher'
alias goijt='cd $IJ_HOME/../imagej-tutorials'
alias goil='cd $IMGLIB_HOME'
alias goitk='cd $ITK_HOME'
alias goj2l='cd $LOCI_SOFTWARE/jar2lib/src/main/resources'
alias goome='cd $OMERO_HOME'
alias gonar='cd $NAR_HOME'
alias gop='cd $BF_HOME/components/loci-plugins/src/loci/plugins'
alias gos='cd $SCIFIO_HOME'
alias gosc='cd $SCRIPTS_DIR'
alias gosj='cd $SCIJAVA'
alias gov='cd $LOCI_SOFTWARE/visbio/src/main/java/loci/visbio'
alias gow='cd $LOCI_INTERNAL/WiscScan'
alias gox='cd $BF_HOME/components/ome-xml/src/ome/xml'

# useful aliases - machines
alias dev='ssh dev'
alias drupal='ssh drupal'
alias ome='ssh ome'
alias rook='ssh rook'
alias server='ssh server'
alias skynet='ssh skynet'
alias tera='ssh tera'

# setup - Bio-Formats
export DATA=$HOME/share/data

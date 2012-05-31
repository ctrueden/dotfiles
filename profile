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
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

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
  . $BREW/etc/bash_completion
fi

# color prompt
PS1=': ${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@${HOSTNAME}\[\033[00m\] \[\033[01;34m\]\w\[\033[00m\]\n'

# include git completion
if [ -f /etc/bash_completion.d/git ]; then
  # Ubuntu Linux with bash completion ("sudo aptitude install bash-completion")
  export GIT_COMPLETION=1
fi
if [ -f "$BREW/etc/bash_completion.d/git-completion.bash" ]
then
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

# setup - CVS/SVN
export CVS_RSH=ssh
export EDITOR=vi
export VISUAL=$EDITOR

# setup - bash
# do not autocomplete .svn folders
export FIGNORE=.svn

# setup - Maven
export MAVEN_OPTS=-Xmx1536m

# useful dirs
export HOME_JAVA=~/code/Home/java
export LOCI_SOFTWARE=~/code/LOCI
export LOCI_INTERNAL=~/code/LOCI/internal
export SCIFIO=~/code/OME/scifio
export IJ_HOME=~/code/ImageJ/imagej
export IMGLIB_HOME=~/code/ImageJ/imglib
export FIJI_HOME=~/code/ImageJ/fiji
export CELLPROFILER_HOME=~/code/Other/CellProfiler/CellProfiler
export VISAD=~/code/Other/visad
export BF_CPP_DIR=$SCIFIO/components/bio-formats/cppwrap
export BF_ITK_DIR=$SCIFIO/components/native/bf-itk-pipe
export CONFIG_DIR=$SCRIPTS_DIR/config
export LOCI_TRUNK=http://dev.loci.wisc.edu/svn/software/trunk

# setup - Bio-Formats ITK plugin
#export ITK_AUTOLOAD_PATH=$BF_ITK_DIR/build/lib/ITKFactories

# setup - OME perl
export OME=~/code/OME/ome
export OMEJAVA=$OME/src/java
export PERL5LIB=$OME/src/perl2

# setup - WrapITK
export DYLD_LIBRARY_PATH=/usr/lib/InsightToolkit/:$DYLD_LIBRARY_PATH
export PYTHONPATH=\
/Users/curtis/code/Other/CellProfiler/CellProfiler:\
/usr/lib/InsightToolkit/WrapITK/Python/:\
$PYTHONPATH

# setup - Java
if [ "$OS_NAME" == "Darwin" ]; then
  export JAVA_HOME=/Library/Java/Home
elif [ "$OS_NAME" == "Linux" ]; then
  export JAVA_HOME=/usr/lib/jvm/java-6-sun
fi

# setup - Java classpath
unset CLASSPATH
export CP=\
~/java:\
$HOME_JAVA:\
$HOME_JAVA/utils
for jar in $LOCI_SOFTWARE/projects/*/target/*.jar
do
  export CP=$CP:$jar
done
for dir in $SCIFIO/components/*/utils
do
  export CP=$CP:$dir
done
for jar in $SCIFIO/artifacts/*.jar
do
  if [ ${jar: -14} != 'loci_tools.jar' ] && [ ${jar: -13} != 'ome_tools.jar' ]
  then
    export CP=$CP:$jar
  fi
done
#export CP=$CP:$VISAD

# setup - scripts
export SCRIPTS_DIR=~/code/Dropbox/scripts

# setup - path
export PATH=\
$JAVA_HOME/bin:\
~/bin:\
$SCRIPTS_DIR/bin:\
$SCIFIO/tools:\
$FIJI_HOME/bin:\
$PATH

# setup - Homebrew
if [ "$OS_NAME" == "Darwin" ]; then
  export PATH=~/brew/bin:$PATH
fi

# setup - jikes
#export JRELIB=/System/Library/Frameworks/JavaVM.framework/Classes
#export JREEXTLIB=/System/Library/Java/Extensions
#export BOOTCLASSPATH=\
#$JRELIB/classes.jar:\
#$JRELIB/ui.jar:\
#$JREEXTLIB/j3dcore.jar:\
#$JREEXTLIB/j3dutils.jar:\
#$JREEXTLIB/vecmath.jar
#export JIKESARGS='-target 1.4 -source 1.4 +Pmodifier-order +Predundant-modifiers +Pnaming-convention +Pno-effective-java +Punused-type-imports +Punused-package-imports'
#alias jc='jikes $JIKESARGS'

# setup - jmp
#export LD_LIBRARY_PATH=/usr/local/lib
#alias jmp='java -Xrunjmp'

# setup - jni
#export C_INCLUDE_PATH=$JAVA_HOME/include
#export CPLUS_INCLUDE_PATH=$C_INCLUDE_PATH

# setup - MeVisLab + Bio-Formats module
#source /home/curtis/apps/MeVisLab/bin/init.sh
#export MLAB_JNI_LIB=$JAVA_HOME/jre/lib/i386/server/libjvm.so

# setup - ls
if [ "$OS_NAME" == "Linux" ]; then
  alias ls='ls -AF --color=auto'
else
  alias ls='ls -AFG'
fi
#export LSCOLORS="GxGxFxdxCxDxDxhbadGxGx";

# setup - diff
alias diff='git diff --no-index'

# setup - xmllint
export XMLLINT_INDENT=$'\t'

# useful functions
goto() { cd $(dirname "`find . -name $*`"); }
govi() { vi "`find . -name $*`"; }

# useful aliases - Java
alias j='java -cp $CP:.'
alias jc='javac -cp $CP:.'

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
if [ "${OS_NAME:0:6}" == 'CYGWIN' ]; then
  alias clear='cmd /c cls'
fi

# useful aliases - start
if [ "$OS_NAME" == "Darwin" ]; then
  alias start='open'
elif [ "$OS_NAME" == "Linux" ]; then
  alias start='nautilus'
elif [ "${OS_NAME:0:6}" == 'CYGWIN' ]; then
  alias start='cmd /c start'
fi

# useful aliases - ldd
if [ ! -x "`which ldd`" ]; then
  alias ldd='otool -L'
fi

# useful aliases - hex editor
if [ "$OS_NAME" == "Darwin" ]; then
  alias hex='/Applications/Hex\ Fiend.app/Contents/MacOS/Hex\ Fiend'
else
  alias hex='ghex2'
fi

# useful aliases - Maven
if [ "$OS_NAME" == "Darwin" ]; then
  alias mvn2='~/brew/Cellar/maven2/2.2.1/bin/mvn'
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
alias goa='cd $SCIFIO/components/autogen/src'
alias gobfcpp='cd $BF_CPP_DIR'
alias gobfitk='cd $BF_ITK_DIR'
alias goc='cd $SCIFIO/components/common/src/loci/common'
alias gocfg='cd $CONFIG_DIR'
alias gocp='cd $CELLPROFILER_HOME'
alias god='cd ~/data'
alias gof='cd $SCIFIO/components/bio-formats/src/loci/formats'
alias gofi='cd $FIJI_HOME'
alias goij='cd $IJ_HOME'
alias goil='cd $IMGLIB_HOME'
alias goj2l='cd $LOCI_SOFTWARE/jar2lib/src/main/resources'
alias gon='cd $SCIFIO/components/legacy/ome-notes/src/loci/ome/notes'
alias goo='cd $SCIFIO/components/ome-plugins/src/loci/plugins/ome'
alias gop='cd $SCIFIO/components/loci-plugins/src/loci/plugins'
alias gos='cd $SCIFIO'
alias got='cd $SCIFIO/components/test-suite/src/loci/tests/testng'
alias gov='cd $LOCI_SOFTWARE/visbio/src/main/java/loci/visbio'
alias gow='cd $LOCI_INTERNAL/WiscScan'
alias gox='cd $SCIFIO/components/ome-xml/src/ome/xml'

# useful aliases - machines
alias dev='ssh dev.loci.wisc.edu'
alias drupal='ssh drupal@skynet.loci.wisc.edu'
alias ome='ssh open.microscopy.wisc.edu'
alias pacific='ssh fiji.sc'
alias server='ssh server.microscopy.wisc.edu'
alias skynet='ssh skynet.loci.wisc.edu'

# setup - Fiji (Fake fails if JAVA_HOME is set)
unset JAVA_HOME

#export LOCI_DEVEL=1 # for LOCI command line tools

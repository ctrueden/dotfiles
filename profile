# ~/.profile

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
#export HISTCONTROL=ignoredups

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# color prompt
PS1='\[\033[01;32m\]\u@${HOSTNAME}\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# programmatic completion features
if [ -f /opt/local/etc/bash_completion ]; then
    . /opt/local/etc/bash_completion
fi

# Terminal title
export TERM_TITLE="Terminal"
echo -n -e "\033]0;$TERM_TITLE\007"

# setup - CVS/SVN
export CVS_RSH=ssh
export EDITOR=vi
export VISUAL=$EDITOR

# useful dirs
export HOME_JAVA=~/code/Home/java
export LOCI_JAVA=~/code/LOCI/java
export IJ_HOME=~/code/LOCI/imagej
export IMGLIB_HOME=~/code/LOCI/imglib
export FIJI_HOME=~/code/Fiji/fiji
export CELLPROFILER_HOME=~/code/Other/CellProfiler/CellProfiler
export VISAD=~/code/VisAD
export BF_CPP_DIR=$LOCI_JAVA/components/native/bf-cpp
export BF_ITK_DIR=$LOCI_JAVA/components/native/bf-itk
export FARSIGHT_DIR=~/code/Other/farsight
export NUCLEUS_DIR=$FARSIGHT_DIR/build/ftk/NuclearSegmentation/NucleusEditor
export CONFIG_DIR=~/code/LOCI/misc/curtis/config

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
export JAVA_HOME=/Library/Java/Home

# setup - Java classpath
unset CLASSPATH
export CP=\
~/java:\
$HOME_JAVA:\
$LOCI_$HOME_JAVA/utils:\
$LOCI_JAVA/utils
for dir in $LOCI_JAVA/components/*/utils
do
  export CP=$CP:$dir
done
for jar in $LOCI_JAVA/artifacts/*.jar
do
  if [ ${jar: -14} != 'loci_tools.jar' ] && [ ${jar: -13} != 'ome_tools.jar' ]
  then
    export CP=$CP:$jar
  fi
done
#export CP=$CP:$VISAD

# setup - path
export PATH=\
$JAVA_HOME/bin:\
~/bin:\
~/code/LOCI/misc/curtis/bin:\
$LOCI_JAVA/tools:\
$FIJI_HOME/bin:\
/usr/local/bin:\
$PATH

# setup - MacPorts
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
export MANPATH=/opt/local/share/man:$MANPATH

# setup - jikes
export JRELIB=/System/Library/Frameworks/JavaVM.framework/Classes
export JREEXTLIB=/System/Library/Java/Extensions
export BOOTCLASSPATH=\
$JRELIB/classes.jar:\
$JRELIB/ui.jar:\
$JREEXTLIB/j3dcore.jar:\
$JREEXTLIB/j3dutils.jar:\
$JREEXTLIB/vecmath.jar
export JIKESARGS='-target 1.4 -source 1.4 +Pmodifier-order +Predundant-modifiers +Pnaming-convention +Pno-effective-java +Punused-type-imports +Punused-package-imports'
#alias jc='jikes $JIKESARGS'

# setup - jmp
export LD_LIBRARY_PATH=/usr/local/lib
alias jmp='java -Xrunjmp'

# setup - jni
export C_INCLUDE_PATH=$JAVA_HOME/include
export CPLUS_INCLUDE_PATH=$C_INCLUDE_PATH

# setup - ls
#export LSCOLORS="GxGxFxdxCxDxDxhbadGxGx";
#alias ls='ls -AFG'

# useful functions
goto() { cd $(dirname "`find . -name $*`"); }
govi() { vi "`find . -name $*`"; }

# useful aliases - Java
alias j='java -cp $CP:.'
alias jc='javac -cp $CP:.'

# useful aliases - shell
alias ls='ls -AFG'
alias mv='mv -i'
alias cls='clear;pwd;ls'
alias cdiff='colordiff 2> /dev/null'
alias grep='grep --colour=auto'
alias rgrep='grep -IR --exclude="*\.svn*"'
alias ldd='otool -L'

# useful aliases - apps
alias start='nautilus'
alias hex='/Applications/Hex\ Fiend.app/Contents/MacOS/Hex\ Fiend'
alias slim='j -mx512m loci.slim.SlimPlotter'
alias visbio='j -mx1024m -Dswing.defaultlaf=com.jgoodies.plaf.plastic.Plastic3DLookAndFeel loci.visbio.VisBio'

# useful aliases - navigation
alias up='cd ..'
alias up2='cd ../..'
alias up3='cd ../../..'
alias up4='cd ../../../..'
alias up5='cd ../../../../..'
alias up6='cd ../../../../../..'
alias up7='cd ../../../../../../..'
alias up8='cd ../../../../../../../..'
alias go='cd $LOCI_JAVA'
alias goa='cd $LOCI_JAVA/components/autogen/src'
alias goc='cd $LOCI_JAVA/components/common/src/loci/common'
alias gof='cd $LOCI_JAVA/components/bio-formats/src/loci/formats'
alias gon='cd $LOCI_JAVA/components/legacy/ome-notes/src/loci/ome/notes'
alias goo='cd $LOCI_JAVA/components/ome-plugins/src/loci/plugins/ome'
alias gop='cd $LOCI_JAVA/components/loci-plugins/src/loci/plugins'
alias gos='cd $LOCI_JAVA/components/slim-plotter/src/loci/slim'
alias got='cd $LOCI_JAVA/components/test-suite/src/loci/tests/testng'
alias gov='cd $LOCI_JAVA/components/visbio/src/loci/visbio'
alias gox='cd $LOCI_JAVA/components/ome-xml/src/ome/xml'
alias gobfcpp='cd $BF_CPP_DIR'
alias god='cd ~/data'
alias goij='cd $IJ_HOME'
alias goil='cd $IMGLIB_HOME'
alias gofi='cd $FIJI_HOME'
alias gocp='cd $CELLPROFILER_HOME'
alias goconfig='cd $CONFIG_DIR'
alias gen='cd $LOCI_JAVA && svn up && ant dev-clean dev-compile clean tools'

# useful aliases - machines
alias skyking='ssh skyking.microscopy.wisc.edu'
alias skynet='ssh skynet.loci.wisc.edu'
alias drupal='ssh drupal@skynet.loci.wisc.edu'
alias pacific='ssh rueden@pacific.mpi-cbg.de'
alias daily='scp drupal@skynet.loci.wisc.edu:software/daily/loci_tools.jar $LOCI_ROOT/artifacts/'

# useful aliases - OME
#alias ome-backup='cd ~ && sudo ome data backup -q -a OME-backup && cd -'
#alias ome-restore='cd ~ && sudo apache2ctl restart && sudo ome data restore -a OME-backup.tar && cd -'
# Without the q flag, it will backup OMEIS (which will take quite some time).
# You can back that up separately. OMEIS doesn't care how many back-ends use it
# as a repository (it never reuses its IDs, so there's no possibility of
# conflict). The -a flag is used to specify the archive file.
#alias ome-update='cd ~/cvs && sudo rm -rf OME && cvs -d :ext:ctrueden@cvs.openmicroscopy.org.uk:/home/cvs/ome co OME && cd OME'

# fiji setup (Fake fails if JAVA_HOME is set)
unset JAVA_HOME

#export LOCI_DEVEL=1 # for LOCI command line tools

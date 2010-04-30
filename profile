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
export HOSTNAME=scout
PS1='\[\033[01;32m\]\u@${HOSTNAME}\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# fink setup
test -r /sw/bin/init.sh && . /sw/bin/init.sh

# programmatic completion features
if [ -f /opt/local/etc/bash_completion ]; then
    . /opt/local/etc/bash_completion
fi

# SVN setup
export EDITOR=vi
export VISUAL=$EDITOR

# Perl setup
export OME=~/code/OME/ome
export PERL5LIB=$OME/src/perl2

# WrapITK setup
export DYLD_LIBRARY_PATH=/usr/lib/InsightToolkit/:$DYLD_LIBRARY_PATH
export PYTHONPATH=\
/Users/curtis/code/Other/CellProfiler/CellProfiler:\
/usr/lib/InsightToolkit/WrapITK/Python/:\
$PYTHONPATH

# Java setup
#export JAVA_HOME=/Library/Java/Home
unset JAVA_HOME
export VISAD=~/code/VisAD
export OMEJAVA=~/code/OME/ome/src/java
#export LOCI_DEVEL=1 # for LOCI command line tools
export LOCI_JAVA=~/code/LOCI/java
export HOME_JAVA=~/code/Home/java
export IJ_HOME=~/code/LOCI/imagej
export FIJI_HOME=~/code/Fiji/fiji
export CELLPROFILER_HOME=~/code/Other/CellProfiler/CellProfiler
unset CLASSPATH
export CP=\
$LOCI_JAVA/utils:\
$LOCI_JAVA/components/bio-formats/utils:\
$LOCI_JAVA/components/common/utils:\
$LOCI_JAVA/components/loci-plugins/utils:\
$LOCI_$HOME_JAVA/utils:\
$HOME_JAVA
for jar in $LOCI_JAVA/artifacts/*.jar $LOCI_JAVA/jar/*.jar
do
  if [ "$jar" != "$LOCI_JAVA/jar/jai_imageio.jar" ] # HACK to avoid exception
  then
    export CP=$CP:$jar
  fi
done
alias j='java -cp $CP:.'
alias jc='javac -cp $CP:.'
alias slim='j -mx512m loci.slim.SlimPlotter'
#alias visbio='j -mx1024m -Dapple. loci.visbio.VisBio'

# path setup
export PATH=\
$JAVA_HOME/bin:\
~/bin:\
~/code/LOCI/misc/curtis/bin:\
$LOCI_JAVA/tools:\
/usr/local/bin:\
$PATH

# useful dirs
export BF_CPP_DIR=$LOCI_JAVA/components/native/bf-cpp
export BF_ITK_DIR=$LOCI_JAVA/components/native/bf-itk
export FARSIGHT_DIR=~/code/Other/farsight
export NUCLEUS_DIR=$FARSIGHT_DIR/build/ftk/NuclearSegmentation/NucleusEditor
#export ITK_AUTOLOAD_PATH=$BF_ITK_DIR/build/lib/ITKFactories

# jikes setup
export JRELIB=/System/Library/Frameworks/JavaVM.framework/Classes
export BOOTCLASSPATH=\
$JRELIB/classes.jar:\
$JRELIB/ui.jar
#$JRELIB/ext/j3dcore.jar:\
#$JRELIB/ext/j3dutils.jar:\
#$JRELIB/ext/vecmath.jar
export JIKESARGS='-target 1.4 -source 1.4 +Pmodifier-order +Predundant-modifiers +Pnaming-convention +Pno-effective-java +Punused-type-imports +Punused-package-imports'

# useful aliases
alias up='cd ..'
alias up2='cd ../..'
alias up3='cd ../../..'
alias up4='cd ../../../..'
alias up5='cd ../../../../..'
alias up6='cd ../../../../../..'
alias up7='cd ../../../../../../..'
alias up8='cd ../../../../../../../..'
alias ls='ls -AFG'
alias mv='mv -i'
alias cls='clear;pwd;ls'
alias cdiff='colordiff 2> /dev/null'
alias start='nautilus'
alias grep='grep --colour=auto'
alias rgrep='rgrep -I --exclude=*.svn*'
alias hex='/Applications/Hex\ Fiend.app/Contents/MacOS/Hex\ Fiend'
alias go='cd $LOCI_JAVA'
alias goc='cd $LOCI_JAVA/components/common/src/loci/common'
alias gof='cd $LOCI_JAVA/components/bio-formats/src/loci/formats'
alias gon='cd $LOCI_JAVA/components/legacy/ome-notes/src/loci/ome/notes'
alias gop='cd $LOCI_JAVA/components/loci-plugins/src/loci/plugins'
alias gos='cd $LOCI_JAVA/components/slim-plotter/src/loci/slim'
alias gov='cd $LOCI_JAVA/components/visbio/src/loci/visbio'
alias god='cd ~/data'
alias goij='cd $IJ_HOME'
alias gofi='cd $FIJI_HOME'
alias gocp='cd $CELLPROFILER_HOME'
alias gen='cd $LOCI_JAVA && svn up && ant dev-clean dev-compile clean tools'
alias skyking='ssh skyking.microscopy.wisc.edu'
alias skynet='ssh skynet.loci.wisc.edu'
alias drupal='ssh drupal@skynet.loci.wisc.edu'
alias pacific='ssh rueden@pacific.mpi-cbg.de'

# useful OME aliases
#alias ome-backup='cd ~ && sudo ome data backup -q -a OME-backup && cd -'
#alias ome-restore='cd ~ && sudo apache2ctl restart && sudo ome data restore -a OME-backup.tar && cd -'
# Without the q flag, it will backup OMEIS (which will take quite some time).
# You can back that up separately. OMEIS doesn't care how many back-ends use it
# as a repository (it never reuses its IDs, so there's no possibility of
# conflict). The -a flag is used to specify the archive file.
#alias ome-update='cd ~/cvs && sudo rm -rf OME && cvs -d :ext:ctrueden@cvs.openmicroscopy.org.uk:/home/cvs/ome co OME && cd OME'

# MacPorts Installer addition on 2009-10-23_at_19:34:20: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.


# MacPorts Installer addition on 2009-10-23_at_19:34:20: adding an appropriate MANPATH variable for use with MacPorts.
export MANPATH=/opt/local/share/man:$MANPATH
# Finished adapting your MANPATH environment variable for use with MacPorts.

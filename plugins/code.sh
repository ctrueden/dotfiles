test "$DEBUG" && echo "[dotfiles] Loading plugin 'code'..."

# base directory for all projects
export CODE_BASE="$HOME/code"

# personal projects - https://github.com/ctrueden
export CODE_PERSONAL="$CODE_BASE/ctrueden"
alias goctr='cd $CODE_PERSONAL'

# configuration files
alias gocfg='cd $DOTFILES'

# useful scripts
export CODE_SCRIPTS="$DOTFILES/bin"
alias gosc='cd $CODE_SCRIPTS'
path_prepend "$CODE_SCRIPTS"

# second brain
export CODE_BRAIN="$CODE_PERSONAL/brain"
alias gob='cd $CODE_BRAIN'
alias gobx='cd $CODE_BRAIN/notes/external'

# public projects
alias gomq='cd $CODE_PERSONAL/monoqueue'

# private projects
export CODE_PRIVATE="$CODE_PERSONAL/unsorted-junk"
alias gop='cd $CODE_PRIVATE'
alias gouj='cd $CODE_PRIVATE'

# LOCI projects - https://github.com/uw-loci
export CODE_LOCI="$CODE_BASE/loci"
alias goloci='cd $CODE_LOCI'
alias gols='cd $CODE_LOCI/loci-servers'

# SCIFIO - https://github.com/scifio
export CODE_SCIFIO="$CODE_BASE/scifio/scifio"
alias gos='cd $CODE_SCIFIO'
alias goscli='cd $CODE_SCIFIO/../scifio-cli'
alias gost='cd $CODE_SCIFIO/../scifio-tutorials'

# Bio-Formats - https://github.com/ome/bioformats
export CODE_BF="$CODE_BASE/ome/bioformats"
alias gobf='cd $CODE_BF'

# ImageJ - https://github.com/imagej
export CODE_IJ="$CODE_BASE/imagej"
alias goij='cd $CODE_IJ'
alias goij2='cd $CODE_IJ/imagej2'
alias goij1='cd $CODE_IJ/ImageJ'
alias goij1p='cd $CODE_IJ/ij1-patcher'
alias goijc='cd $CODE_IJ/imagej-common'
alias goijla='cd $CODE_IJ/imagej-launcher'
alias goijle='cd $CODE_IJ/imagej-legacy'
alias goijl='goijle'
alias goijo='cd $CODE_IJ/imagej-omero'
alias goijs='cd $CODE_IJ/imagej-server'
alias goijt='cd $CODE_IJ/tutorials'
alias goijup='cd $CODE_IJ/imagej-updater'
alias goiju='goijup'
alias goijw='cd $CODE_IJ/imagej.github.io'
alias gopij='cd $CODE_IJ/pyimagej'

# ImageJ OPS - https://github.com/imagej/imagej-ops
export CODE_OPS="$CODE_IJ/imagej-ops"
alias goops='cd $CODE_OPS'

# ImgLib2 - https://github.com/imglib/imglib2
export CODE_IMGLIB="$CODE_BASE/imglib/imglib2"
alias goil='cd $CODE_IMGLIB'
alias goila='cd $CODE_IMGLIB/../imglib2-algorithm'
alias goilaf='cd $CODE_IMGLIB/../imglib2-algorithm-fft'
alias goilag='cd $CODE_IMGLIB/../imglib2-algorithm-gpl'
alias goilij='cd $CODE_IMGLIB/../imglib2-ij'
alias goilr='goilroi'
alias goilrt='cd $CODE_IMGLIB/../imglib2-realtransform'
alias goilroi='cd $CODE_IMGLIB/../imglib2-roi'
alias goilt='goilte'
alias goilte='cd $CODE_IMGLIB/../imglib2-tests'
alias goiltu='cd $CODE_IMGLIB/../imglib2-tutorials'

# ITK - https://github.com/Kitware/ITK
export CODE_ITK="$HOME/code/kitware/ITK"
alias goitk='cd $CODE_ITK'

# Fiji - https://github.com/fiji
export CODE_FIJI="$CODE_BASE/fiji/fiji"
alias gofi='cd $CODE_FIJI'
alias gotm='cd $CODE_FIJI/../TrackMate'
alias gocb='cd $CODE_FIJI/../cookbook'
path_prepend "$CODE_FIJI/bin"

# BigDataViewer - https://github.com/bigdataviewer
export CODE_BDV="$CODE_BASE/bdv"
alias gobdv='cd $CODE_BDV'

# BigVolumeViewer - https://github.com/bigdataviewer/bigvolumeviewer-core
export CODE_3D="$CODE_BASE/3d"
alias gobvv='cd $CODE_3D/bigvolumeviewer-core'

# JEX
export CODE_JEX="$CODE_BASE/sj-stuff/JEX"
alias gojex='cd $CODE_JEX'

# SciJava - https://github.com/scijava
export CODE_SCIJAVA="$CODE_BASE/scijava"
alias gopa='cd $CODE_SCIJAVA/parsington'
alias gopsj='cd $CODE_SCIJAVA/pom-scijava'
alias gopsb='cd $CODE_SCIJAVA/pom-scijava-base'
alias gosjc='cd $CODE_SCIJAVA/scijava-common'
alias gosjs='cd $CODE_SCIJAVA/scijava-scripts'
path_prepend "$CODE_SCIJAVA/scijava-scripts"

# CellProfiler - https://github.com/CellProfiler/CellProfiler
export CODE_CELLPROFILER="$CODE_BASE/cellprofiler/CellProfiler"
alias gocp='cd $CODE_CELLPROFILER'

# Appose
export CODE_APPOSE="$CODE_BASE/appose"
alias goaj='cd $CODE_APPOSE/appose-java'
alias goap='cd $CODE_APPOSE/appose-python'

# napari
export CODE_NAPARI="$CODE_BASE/napari"
alias gonij='cd $CODE_NAPARI/napari-imagej'

# Jump to directory by string fragment.
# Augments oh-my-zsh's z plugin.
if alias z >/dev/null 2>&1
then
  unalias z
fi
z() {
  local d=""
  if command -v _z >/dev/null
  then
    if [ $# -eq 0 ]
    then
      zshz
      return
    else
      d=$(zshz -e $@)
    fi
  fi
  if [ -z "$d" ]
  then
    # Nothing cached by z; look in $CODE_BASE as a fallback.
    d=$(find "$CODE_BASE"/* -maxdepth 1 -type d -wholename '*'"$@"'*' | head -n1)
  fi
  if [ "$d" ]
  then
    cd "$d"
  fi
}

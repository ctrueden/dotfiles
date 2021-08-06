# base directory for all projects
export CODE_BASE="$HOME/code"

# personal projects - https://github.com/ctrueden
export CODE_PERSONAL="$CODE_BASE/ctrueden"
alias goctr='cd $CODE_PERSONAL'

# configuration files
alias gocfg='cd $DOTFILES'

# useful scripts
export CODE_SCRIPTS="$CODE_PERSONAL/ctr-scripts"
alias gosc='cd $CODE_SCRIPTS'

# private projects
export CODE_PRIVATE="$CODE_PERSONAL/unsorted-junk"
alias gop='cd $CODE_PRIVATE'

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
export CODE_IJ="$CODE_BASE/imagej/imagej2"
alias goij='cd $CODE_IJ'
alias goij1='cd $CODE_IJ/../ImageJA'
alias goij1p='cd $CODE_IJ/../ij1-patcher'
alias goij1t='cd $CODE_IJ/../ij1-tests'
alias goijc='cd $CODE_IJ/../imagej-common'
alias goijla='cd $CODE_IJ/../imagej-launcher'
alias goijle='cd $CODE_IJ/../imagej-legacy'
alias goijl='goijle'
alias goijo='cd $CODE_IJ/../imagej-omero'
alias goijs='cd $CODE_IJ/../imagej-server'
alias goijt='cd $CODE_IJ/../tutorials'
alias goijup='cd $CODE_IJ/../imagej-updater'
alias goijus='cd $CODE_IJ/../imagej-usage'
alias goiju='goijup'

# ImageJ OPS - https://github.com/imagej/imagej-ops
export CODE_OPS="$CODE_IJ/../imagej-ops"
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
alias goils='cd $CODE_IMGLIB/../imglib2-script'
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

# BigDataViewer - https://github.com/bigdataviewer
export CODE_BDV="$CODE_BASE/bdv"
alias gobdv='cd $CODE_BDV'

# JEX
export CODE_JEX="$CODE_BASE/sj-stuff/jex"
alias gojex='cd $CODE_JEX'

# SciJava - https://github.com/scijava
export CODE_SCIJAVA="$CODE_BASE/scijava"
alias gopsj='cd $CODE_SCIJAVA/pom-scijava'
alias gopsb='cd $CODE_SCIJAVA/pom-scijava-base'
alias gosjc='cd $CODE_SCIJAVA/scijava-common'
alias gosjs='cd $CODE_SCIJAVA/scijava-scripts'

# NAR - https://github.com/maven-nar/nar-maven-plugin
export CODE_NAR="$CODE_BASE/maven/nar-maven-plugin"
alias gonar='cd $CODE_NAR'

# CellProfiler - https://github.com/CellProfiler/CellProfiler
export CODE_CELLPROFILER="$CODE_BASE/cellprofiler/CellProfiler"
alias gocp='cd $CODE_CELLPROFILER'

# SLIM Curve - https://github.com/slim-curve
export CODE_SLIM="$CODE_BASE/slim"
alias goslim='cd $CODE_SLIM'

# VisAD
export CODE_VISAD="$CODE_BASE/visad/visad"

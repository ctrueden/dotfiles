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

# oh-my-zsh
export PATH_OMZ="$PATH_CODE/omz"
alias goomz='cd $PATH_OMZ'

# useful scripts
export PATH_SCRIPTS="$PATH_PERSONAL/ctr-scripts"
alias gosc='cd $PATH_SCRIPTS'

# private projects
export PATH_PRIVATE="$PATH_PERSONAL/ctr-private"
alias gop='cd $PATH_PRIVATE'

# LOCI projects - https://github.com/uw-loci
export PATH_LOCI="$PATH_CODE/loci"
alias goloci='cd $PATH_LOCI'
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
alias gosjep='cd $PATH_SCIJAVA/scijava-expression-parser'
alias gosjs='cd $PATH_SCIJAVA/scijava-scripts'

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

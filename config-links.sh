#!/bin/sh

set -e

CONFIG_DIR=$(cd "$(dirname $0)"; pwd)
cd
USER_DIR=$(pwd)
LINK_DIR=${CONFIG_DIR#$USER_DIR/}

OS_NAME=$(uname)
STAMP=$(date +%Y%m%dT%H%M%S)

FILES=(
.bashrc
.forward
.gitconfig
.mrconfig
.plan
.vimrc
.zshrc
Library/KeyBindings
)

for f in ${FILES[@]}
do
  if [ -h $f ]; then
    (set -x; rm $f)
  fi
  if [ -a $f ]; then
    bk=$f.$STAMP
    (set -x; mv $f $bk)
  fi
done

(
  set -x
  ln -s $LINK_DIR/bashrc.stub .bashrc
  ln -s $LINK_DIR/forward .forward
  ln -s $LINK_DIR/gitconfig .gitconfig
  ln -s $LINK_DIR/mrconfig .mrconfig
  ln -s $LINK_DIR/plan .plan
  ln -s $LINK_DIR/vimrc .vimrc
  ln -s $LINK_DIR/zshrc.stub .zshrc
)

case "$(uname)" in
  Darwin)
    cd Library
    (set -x; ln -s ../$LINK_DIR/KeyBindings)
    cd ..
    ;;
esac

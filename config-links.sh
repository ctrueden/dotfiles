#!/bin/bash

set -e

CONFIG_DIR=`cd "$(dirname $0)"; pwd`
cd
USER_DIR=`pwd`
LINK_DIR=${CONFIG_DIR#$USER_DIR/}

OS_NAME=`uname`
STAMP=`date +%Y%m%dT%H%M%S`

FILES=(
.bashrc
.forward
.gitconfig
.keystore
.mrconfig
.plan
.vim
.vimrc
.ssh/authorized_keys
.ssh/config
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
  ln -s $LINK_DIR/bashrc .bashrc
  ln -s $LINK_DIR/forward .forward
  ln -s $LINK_DIR/gitconfig .gitconfig
  ln -s $LINK_DIR/restless.keystore .keystore
  ln -s $LINK_DIR/mrconfig .mrconfig
  ln -s $LINK_DIR/plan .plan
  ln -s $LINK_DIR/vim .vim
  ln -s $LINK_DIR/vimrc .vimrc
)

cd .ssh
(
  set -x
  ln -s ../$LINK_DIR/ssh-authorized_keys authorized_keys
  ln -s ../$LINK_DIR/ssh-config config
)
cd ..

if [ "$OS_NAME" == "Darwin" ]; then
  cd Library
  (set -x; ln -s ../$LINK_DIR/KeyBindings)
  cd ..
fi

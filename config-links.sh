#!/bin/sh

set -e

CONFIG_DIR=`cd "$(dirname $0)"; pwd`
cd
USER_DIR=`pwd`
LINK_DIR=${CONFIG_DIR#$USER_DIR/}

OS_NAME=`uname`
STAMP=`date +%Y%m%dT%H%M%S`

FILES=(
.ant-global.properties
.forward
.gitconfig
.keystore
.plan
.vim
.vimrc
.ssh/config
Library/KeyBindings
)

if [ "$OS_NAME" == "Linux" ]; then
  FILES=("${FILES[@]}" .bashrc)
else
  FILES=("${FILES[@]}" .profile)
fi

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
  ln -s $LINK_DIR/ant-global.properties .ant-global.properties
  ln -s $LINK_DIR/forward .forward
  ln -s $LINK_DIR/gitconfig .gitconfig
  ln -s $LINK_DIR/restless.keystore .keystore
  ln -s $LINK_DIR/plan .plan
  ln -s $LINK_DIR/vim .vim
  ln -s $LINK_DIR/vimrc .vimrc
)

if [ "$OS_NAME" == "Linux" ]; then
  (set -x; ln -s $LINK_DIR/profile .bashrc)
else
  (set -x; ln -s $LINK_DIR/profile .profile)
fi

cd .ssh
(set -x; ln -s ../$LINK_DIR/ssh-config config)
cd ..

if [ "$OS_NAME" == "Darwin" ]; then
  cd Library
  (set -x; ln -s ../$LINK_DIR/KeyBindings)
  cd ..
fi

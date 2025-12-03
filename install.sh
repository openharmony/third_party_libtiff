#!/bin/bash

SRC_DIR="$1"
CODE_DIR="$2"

set -e
if [ "$SRC_DIR" == "" ] || [ "$CODE_DIR" == "" ]; then
    exit 1
fi

mkdir -p $CODE_DIR
cp -r $SRC_DIR/* $CODE_DIR
rm -rf $CODE_DIR/.git

CURRENT_DIR=$(pwd)
cd $CODE_DIR
sh ./autogen.sh
sh ./configure
cmake . -DCMAKE_BUILD_TYPE=Release
cd "$CURRENT_DIR"

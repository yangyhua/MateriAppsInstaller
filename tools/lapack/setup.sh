#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../../scripts/util.sh
. $SCRIPT_DIR/version.sh
set_prefix

sh $SCRIPT_DIR/download.sh

cd $BUILD_DIR
if [ -d ${__NAME__}-${__VERSION__} ]; then :; else
  check tar xf $SOURCE_DIR/${__NAME__}-${__VERSION__}.tar.gz
  check tar xf $SOURCE_DIR/${__NAME_BLAS__}-${__VERSION_BLAS__}.tar.gz -C ${__NAME__}-${__VERSION__}
  ln -s OpenBLAS-${__VERSION_BLAS__} ${__NAME__}-${__VERSION__}/openblas
  if [ -f $SCRIPT_DIR/patch/${__NAME__}-${__VERSION__}.patch ]; then
    cd ${__NAME__}-${__VERSION__}
    cat $SCRIPT_DIR/patch/${__NAME__}-${__VERSION__}.patch | patch -p1
  fi
fi

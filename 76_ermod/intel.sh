#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh
LOG=$BUILD_DIR/ermod-$ERMOD_VERSION-$ERMOD_PATCH_VERSION.log

PREFIX="$PREFIX_APPS/ermod/ermod-$ERMOD_VERSION-$ERMOD_PATCH_VERSION"

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

sh $SCRIPT_DIR/setup.sh
rm -rf $LOG
cd $BUILD_DIR/ermod_$ERMOD_VERSION
cd source
start_info | tee -a $LOG
echo "[make]" | tee -a $LOG
check ./configure --prefix=$PREFIX CC=icc FC=ifort
cd vmdplugins
mkdir -p compile
check make dcdplugin.so gromacsplugin.so CC=icc CCFLAGS='-O3 -g -fPIC' | tee -a $LOG
cd ..
check make | tee -a $LOG
echo "[make install]" | tee -a $LOG
$SUDO_APPS make install | tee -a $LOG
finish_info | tee -a $LOG

cat << EOF > $BUILD_DIR/ermodvars.sh
. $PREFIX_TOOL/env.sh
export ERMOD_ROOT=$PREFIX
export PATH=\$ERMOD_ROOT/bin:\$PATH
EOF
ERMODVARS_SH=$PREFIX_APPS/ermod/ermodvars-$ERMOD_VERSION-$ERMOD_PATCH_VERSION.sh
$SUDO_APPS rm -f $ERMODVARS_SH
$SUDO_APPS cp -f $BUILD_DIR/ermodvars.sh $ERMODVARS_SH
$SUDO_APPS cp -f $LOG $PREFIX_APPS/ermod
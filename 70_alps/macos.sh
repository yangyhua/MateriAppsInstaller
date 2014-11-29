#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh
LOG=$BUILD_DIR/alps-$ALPS_VERSION.log

PREFIX_ALPS="$PREFIX_APPS/alps"

if [ -d $PREFIX_ALPS/alps-$ALPS_VERSION ]; then
  echo "Error: $PREFIX_ALPS/alps-$ALPS_VERSION exists"
  exit 127
fi

cd $BUILD_DIR
if [ -d alps-$ALPS_VERSION ]; then :; else
  if [ -f $HOME/source/alps-$ALPS_VERSION.tar.gz ]; then
    check tar zxf $HOME/source/alps-$ALPS_VERSION.tar.gz
  else
    check wget -O - http://exa.phys.s.u-tokyo.ac.jp/archive/source/alps-$ALPS_VERSION.tar.gz | tar zxf -
  fi
  cd alps-$ALPS_VERSION
  patch -p1 < $SCRIPT_DIR/macos-accelerate.patch
fi

rm -rf $BUILD_DIR/alps-build-$ALPS_VERSION $LOG
mkdir -p $BUILD_DIR/alps-build-$ALPS_VERSION
cd $BUILD_DIR/alps-build-$ALPS_VERSION
start_info | tee -a $LOG
echo "[cmake]" | tee -a $LOG
check cmake -DCMAKE_INSTALL_PREFIX=$PREFIX_ALPS/alps-$ALPS_VERSION \
  -DCMAKE_C_COMPILER="/opt/local/bin/gcc" -DCMAKE_CXX_COMPILER="/opt/local/bin/g++" -DCMAKE_Fortran_COMPILER="/opt/local/bin/gfortran" \
  -DPYTHON_INTERPRETER="/opt/local/bin/python2.7" \
  -DBoost_ROOT_DIR=$BOOST_ROOT \
  -DALPS_ENABLE_OPENMP=ON -DALPS_ENABLE_OPENMP_WORKER=ON \
  -DALPS_BUILD_FORTRAN=ON -DALPS_BUILD_TESTS=ON -DALPS_BUILD_PYTHON=ON \
  $BUILD_DIR/alps-$ALPS_VERSION | tee -a $LOG

echo "[make]" | tee -a $LOG
check make -j2 | tee -a $LOG
echo "[make install]" | tee -a $LOG
$SUDO_APPS make install | tee -a $LOG
echo "[ctest]" | tee -a $LOG
ctest | tee -a $LOG
finish_info | tee -a $LOG

cat << EOF > $BUILD_DIR/alpsvars-$ALPS_VERSION.sh
. $PREFIX_TOOL/env.sh
. $PREFIX_ALPS/alps-$ALPS_VERSION/bin/alpsvars.sh
EOF
$SUDO_APPS cp -f $BUILD_DIR/alpsvars-$ALPS_VERSION.sh $PREFIX_ALPS/
$SUDO_APPS cp -f $LOG $PREFIX_ALPS/
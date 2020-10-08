#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../../scripts/util.sh
. $SCRIPT_DIR/version.sh
set_prefix

if [ -f $SOURCE_DIR/${__NAME__}-${__VERSION__}.tar.gz ]; then :; else
  check wget -O $SOURCE_DIR/${__NAME__}-${__VERSION__}.tar.gz https://ftp.gnu.org/gnu/${__NAME__}/${__NAME__}-${__VERSION__}/${__NAME__}-${__VERSION__}.tar.gz
  check wget -O $SOURCE_DIR/gmp-${GMP_VERSION}.tar.bz2 https://ftp.gnu.org/gnu/gmp/gmp-${GMP_VERSION}.tar.bz2
  check wget -O $SOURCE_DIR/mpfr-${MPFR_VERSION}.tar.bz2 https://ftp.gnu.org/gnu/mpfr/mpfr-${MPFR_VERSION}.tar.bz2
  check wget -O $SOURCE_DIR/mpc-${MPC_VERSION}.tar.gz https://ftp.gnu.org/gnu/mpc/mpc-${MPC_VERSION}.tar.gz
  check wget -O $SOURCE_DIR/isl-${ISL_VERSION}.tar.bz2 https://${__NAME__}.gnu.org/pub/${__NAME__}/infrastructure/isl-${ISL_VERSION}.tar.bz2
fi

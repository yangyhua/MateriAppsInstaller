if [ -z "$SCALAPACK_LIBRARIES" ]; then
  USE_SCALAPACK=OFF
else
  USE_SCALAPACK=ON
fi

${CMAKE} \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCMAKE_VERBOSE_MAKEFILE=1 \
  -DCMAKE_C_FLAGS="${MA_EXTRA_FLAGS}" \
  -DCMAKE_Fortran_FLAGS="${MA_EXTRA_FLAGS}" \
  -DUSE_SCALAPACK=${USE_SCALAPACK} \
  -DSCALAPACK_LIBRARIES=${SCALAPACK_LIBRARIES} \
  -DCONFIG=gcc \
  ../ 2>&1 | tee -a $LOG

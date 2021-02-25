mkdir -p build
cd build
${CMAKE} -DCMAKE_INSTALL_PREFIX=$PREFIX \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_C_COMPILER=mpicc -DCMAKE_Fortran_COMPILER=mpif90 \
  -DBUILD_SHARED_LIBS=ON -DBUILD_STATIC_LIBS=OFF  \
  ..

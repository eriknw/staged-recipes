#!/bin/bash

if [ `uname` == Darwin ]; then
    # From toolchain
    # for Mac OSX
    export CC=clang
    export CXX=clang++
    export MACOSX_VERSION_MIN="10.9"
    export MACOSX_DEPLOYMENT_TARGET="${MACOSX_VERSION_MIN}"
    export CMAKE_OSX_DEPLOYMENT_TARGET="${MACOSX_VERSION_MIN}"
    export CFLAGS="${CFLAGS} -mmacosx-version-min=${MACOSX_VERSION_MIN}"
    export CXXFLAGS="${CXXFLAGS} -mmacosx-version-min=${MACOSX_VERSION_MIN}"
    export CXXFLAGS="${CXXFLAGS} -stdlib=libc++"
    export LDFLAGS="${LDFLAGS} -headerpad_max_install_names"
    export LDFLAGS="${LDFLAGS} -mmacosx-version-min=${MACOSX_VERSION_MIN}"
    export LDFLAGS="${LDFLAGS} -lc++"
    export LINKFLAGS="${LDFLAGS}"
    # needed otherwise linking fails
    export DYLD_FALLBACK_LIBRARY_PATH=$PREFIX/lib

cmake -D CMAKE_INSTALL_PREFIX=$PREFIX \
    -D PYTHON_EXE=$PYTHON \
    -D INSTALL_PYTHON_USING_PREFIX=OFF \
	-D BOOST_INCLUDE_DIR=$PREFIX/include \
	-D BOOST_LIB_PATH=$PREFIX/lib \
	-D GDAL_INCLUDE_DIR=$PREFIX/include \
	-D GDAL_LIB_PATH=$PREFIX/lib \
	-D HDF5_INCLUDE_DIR=$PREFIX/include \
	-D HDF5_LIB_PATH=$PREFIX/lib \
	-D XERCESC_INCLUDE_DIR=$PREFIX/include \
	-D XERCESC_LIB_PATH=$PREFIX/lib \
	-D GSL_INCLUDE_DIR=$PREFIX/include \
	-D GSL_LIB_PATH=$PREFIX/lib \
	-D GEOS_INCLUDE_DIR=$PREFIX/include \
	-D GEOS_LIB_PATH=$PREFIX/lib \
	-D MUPARSER_INCLUDE_DIR=$PREFIX/include \
	-D MUPARSER_LIB_PATH=$PREFIX/lib \
	-D CGAL_INCLUDE_DIR=$PREFIX/include \
	-D CGAL_LIB_PATH=$PREFIX/lib \
	-D GMP_INCLUDE_DIR=$PREFIX/include \
	-D GMP_LIB_PATH=$PREFIX/lib \
	-D MPFR_INCLUDE_DIR=$PREFIX/include \
	-D MPFR_LIB_PATH=$PREFIX/lib \
	-D KEA_INCLUDE_DIR=$PREFIX/include \
	-D KEA_LIB_PATH=$PREFIX/lib \
    -D CMAKE_BUILD_TYPE=Release \
	.

make -j $CPU_COUNT
make install

# Must run the tests now as they need the source tree
cd python_tests/RSGISLibTests
$PYTHON RSGIStests.py --all

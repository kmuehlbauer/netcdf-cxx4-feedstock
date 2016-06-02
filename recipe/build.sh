#!/usr/bin/env bash

# Build shared.
# cmake -D CMAKE_INSTALL_PREFIX=$PREFIX \
#      -D CMAKE_INSTALL_LIBDIR:PATH=$PREFIX/lib \
#      -D BUILD_SHARED_LIBS=ON \
#      -D NCXX_ENABLE_TESTS=ON \
#      -D ENABLE_DOXYGEN=OFF \
#      $SRC_DIR
#make
#ctest
#make install

if [ "$(uname)" == "Darwin" ]
then
    # for Mac OSX
    export CC=clang
    export CXX=clang++
    export MACOSX_VERSION_MIN="10.7"
    export MACOSX_DEPLOYMENT_TARGET="${MACOSX_VERSION_MIN}"
    export CXXFLAGS="${CXXFLAGS} -mmacosx-version-min=${MACOSX_VERSION_MIN}"
    export CXXFLAGS="${CXXFLAGS} -stdlib=libc++ -std=c++11"
    export LDFLAGS="${LDFLAGS} -mmacosx-version-min=${MACOSX_VERSION_MIN}"
    export LDFLAGS="${LDFLAGS} -stdlib=libc++ -lc++"
    export LINKFLAGS="${LDFLAGS}"
    # See http://www.unidata.ucar.edu/support/help/MailArchives/netcdf/msg11939.html
    export DYLD_LIBRARY_PATH=${PREFIX}/lib
elif [ "$(uname)" == "Linux" ]
then
    # for Linux
    export CC=gcc
    export CXX=g++
    export CXXFLAGS="${CXXFLAGS} -DBOOST_MATH_DISABLE_FLOAT128"
    export LDFLAGS="${LDFLAGS}"
    export LINKFLAGS="${LDFLAGS}"
else
    echo "This system is unsupported by the toolchain."
    exit 1
fi

export CFLAGS="${CFLAGS} -m${ARCH}"
export CXXFLAGS="${CXXFLAGS} -m${ARCH}"

autoreconf -if

CPPFLAGS=-I$PREFIX/include LDFLAGS=-L$PREFIX/lib ./configure --prefix=$PREFIX

make
make check
make install

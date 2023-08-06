#!/bin/bash

set -e

# static by default on macos and shared for other os
CONFIG="shared"
TYPE="Release"
WIN_RUNTIME="MD"
ARCH="x86_64"
DEPLOY="ON"
VS_VER="2019"
OS="windows"
DISTRIB=""

# first detect your os
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
    DISTRIB=$(source /etc/lsb-release && echo $DISTRIB_ID $DISTRIB_RELEASE)
elif [[ "$OSTYPE" == "cygwin" ]]; then
    OS="windows"
elif [[ "$OSTYPE" == "msys" ]]; then
    OS="windows"
elif [[ "$OSTYPE" == "win32" ]]; then
    OS="windows"
elif [[ "$OSTYPE" == darwin* ]]; then
    OS="macos"
fi

helper() {
    echo "[options]"
    echo " -c|--config  Build configuration:"
    echo "              static"
    echo "              shared"
    echo " -t|--type    Build type:"
    echo "              Release"
    echo "              Debug"
    echo " -a|--arch    Architecture:"
    echo "              x86_64"
    echo "              armv8"
    echo "              armv7"
    echo " -v|--vs_ver     VS version:"
    echo "                 2022"
    echo "                 2019"
    echo "                 2017"
    echo " -h|--help    Show helper text"
    
    echo "[example]"
    echo "./build.sh -c static -t Release -a x86_64 -d OFF -s ON"
    exit 1
}

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -c|--config)
    CONFIG="$2"
    shift # past argument
    shift # past value
    ;;
    -a|--arch)
    ARCH="$2"
    shift # past argument
    shift # past value
    ;;
    -h|--help)
    helper
    ;;
    -t|--type)
    TYPE="$2"
    shift # past argument
    shift # past value
    ;;
    -v|--vs_ver)
    VS_VER="$2"
    shift # past argument
    shift # past value
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

echo "OPERATING SYSTEM          = ${OS}"
echo "BUILD TYPE                = ${TYPE}"
echo "BUILD CONFIGURATION       = ${CONFIG}"
echo "ARCH                      = ${ARCH}"
echo "VS_VER                    = ${VS_VER}"
echo "WIN_RUNTIME               = ${WIN_RUNTIME}"
echo "LINUX DISTRIBUTION        = ${DISTRIB}"

CONAN_PROFILE="ConanProfileWin.txt"
VS_GEN=(-G "Visual Studio 16 2019" -A x64)
VS_COMPILER_VER=16
CONAN_EXTRA_ARGS=()
CMAKE_EXTRA_ARGS=()

echo "1"

if [ $OS == "windows" -a "$ARCH" == "x86_64" ]; then
    CONAN_PROFILE="ConanProfileWin.txt"
    echo "1.5"
    if [ $VS_VER == "2017" ]; then
        VS_GEN=(-G "Visual Studio 15 2017 Win64")
        VS_COMPILER_VER=15
    elif [ $VS_VER == "2022" ]; then
        VS_GEN=(-G "Visual Studio 17 2022" -A x64)
        VS_COMPILER_VER=17
    fi
elif [ $OS == "linux" -a "$ARCH" == "x86_64" ]; then
    CONAN_PROFILE="ConanProfileLinux.txt"
    if [ "$DISTRIB" == "Ubuntu 18.04" ]; then
        CONAN_EXTRA_ARGS=(-s compiler.version=7)
        # CMAKE_EXTRA_ARGS=(-DCMAKE_CXX_FLAGS="-D_GLIBCXX_USE_CXX11_ABI=0")
    fi
fi
echo "2"

SCRIPT_DIR="$( cd "$(dirname "$0")" ; pwd -P)"
BUILD_DIR=$SCRIPT_DIR/../Release

if [ $TYPE == "Release" ]; then
    BUILD_DIR=$SCRIPT_DIR/../"$TYPE"
else
    TYPE="Debug"
    BUILD_DIR=$SCRIPT_DIR/../"$TYPE"
    WIN_RUNTIME="MDd"
fi

SHARED_TRUE_FALSE="True"
SHARED_ON_OFF="ON"
if [ $CONFIG == "static" ]; then
    SHARED_TRUE_FALSE="False"
    SHARED_ON_OFF="OFF"
fi

echo "SCRIPT_DIR  = ${SCRIPT_DIR}"
echo "BUILD_DIR   = ${BUILD_DIR}"

# build
mkdir -p $BUILD_DIR
cd $BUILD_DIR

if [ $OS == "windows" -a "$ARCH" == "x86_64" ]; then
    conan install .. --profile ../infra/$CONAN_PROFILE -s build_type=$TYPE -s compiler.version=$VS_COMPILER_VER -s compiler.runtime=$WIN_RUNTIME -o shared=$SHARED_TRUE_FALSE
    cmake .. "${VS_GEN[@]}" \
        -DBUILD_SHARED_LIBS=$SHARED_ON_OFF \
        -DCMAKE_BUILD_TYPE=$TYPE \
        -DTARGET_ARCHITECTURE="win_x86_64"
    cmake --build . --config $TYPE -j8
    cmake --install . --config $TYPE
elif [ $OS == "linux" -a "$ARCH" == "x86_64" ]; then
    conan install .. --profile ../infra/$CONAN_PROFILE -s build_type=$TYPE -o shared=$SHARED_TRUE_FALSE "${CONAN_EXTRA_ARGS[@]}"
    cmake .. \
        -DBUILD_SHARED_LIBS=$SHARED_ON_OFF \
        -DCMAKE_BUILD_TYPE=$TYPE \
        -DTARGET_ARCHITECTURE="linux_x86_64" \
        "${CMAKE_EXTRA_ARGS[@]}"
    cmake --build . --config $TYPE -j8
    cmake --install . --config $TYPE
fi
cmake_minimum_required(VERSION 3.18)

# project 
project(tensorrt_learning LANGUAGES CXX CUDA)

# build options
option(CUDA_USE_STATIC_CUDA_RUNTIME OFF)
option(BUILD_APPS "Build applications" ON)
option(BUILD_SHARED_LIBS "Build shared library" ON)
option(BUILD_WITH_OPENMP "Build with openmp" OFF)
option(GENORATE_VS_DEBUG_INFORM "Generate vs bebug information" OFF)

# settings
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# CUDA complier setuo
set(CMAKE_CUDA_STANDARD 14)
set(CMAKE_CUDA_STANDARD_REQUIRED ON)
set(CMAKE_CUDA_EXTENSIONS OFF)
set(CUDA_LINK_LIBRARIES_KEYWORD PUBLIC)
set(CMAKE_CUDA_RUNTIME_LIBRARY Shared)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_RELEASE ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_RELEASE ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE ${CMAKE_BINARY_DIR}/bin)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_DEBUG ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_DEBUG ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG ${CMAKE_BINARY_DIR}/bin)

set(CMAKE_MODULE_PATH ${CMAKE_BINARY_DIR} ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_SOURCE_DIR}/infra)
set(CMAKE_PREFIX_PATH ${CMAKE_BINARY_DIR} ${CMAKE_PREFIX_PATH})
set(CMAKE_INSTALL_PREFIX ${PROJECT_SOURCE_DIR}/${PROJECT_NAME}_${TARGET_ARCHITECTURE}_${CMAKE_BUILD_TYPE})
set(CMAKE_DEBUG_POSTFIX d)

# 如果你是不同显卡，请设置为显卡对应的号码参考这里：https://developer.nvidia.com/zh-cn/cuda-gpus#compute
# set(CUDA_GEN_CODE "-gencode=arch=compute_75,code=sm_75")


# find package
# set(CUDA_TOOLKIT_ROOT_DIR     "/datav/lean/cuda-11.2")
# set(CUDNN_DIR    "/datav/lean/cudnn8.2.4.15-cuda11.4")
set(TENSORRT_DIR "D:/software/TensorRT-8.6.1.6")
find_package(OpenCV REQUIRED)
find_package(Protobuf)

message(STATUS "cuda version: " ${CUDA_VERSION_STRING})

# Introduce variables:
# * CMAKE_INSTALL_LIBDIR
# * CMAKE_INSTALL_BINDIR
# * CMAKE_INSTALL_INCLUDEDIR
include(GNUInstallDirs)
set_property(GLOBAL PROPERTY USE_FOLDERS TRUE)

# complier options
if (MSVC)
    set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)
    # warning level 4 and all warnings as errors
    # add_compile_options(/W3 #/WX /bigobj /MP8
    #     # disable the following warnings
    #     /wd4275 /wd4251 /wd4068 /wd4819 /wd4309
    # )

    # set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /wd4244 /wd4267 /wd4819")
    # add_link_options(/ignore:4099)

else() # linux
    # if(CMAKE_BUILD_TYPE MATCHES Release)
    #     set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -s")
    #     set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -s")
    # endif()

    # add_compile_options(
    #     -Wall # -Wextra -pedantic -Werror
    #     # disable the following warnings
    #     -Wno-unknown-pragmas
    #     -Wno-maybe-uninitialized
    # )

    # add_link_options(
    #     -Wl,--exclude-libs=ALL
    # )
endif()

# add source code
include(infra/HelperFuncs.cmake)
add_subdirectory(src)

# build apps
if(BUILD_APPS)
    message(STATUS "Build apps project...")
    add_subdirectory(apps)
endif()
set(target_name tensorrt)
add_library(${target_name})

# lib
if(BUILD_SHARED_LIBS)
    target_compile_definitions(${target_name} PRIVATE __BUILD_SHARED__)
    target_compile_definitions(${target_name} PRIVATE __EXPORT_LIBS__)
endif()

file(GLOB_RECURSE SRC_FILES
    ${PROJECT_SOURCE_DIR}/src/tensorrt/*.hpp
    ${PROJECT_SOURCE_DIR}/src/tensorrt/*.cpp
)

target_sources(${target_name}
    PRIVATE
        ${SRC_FILES}
)

target_include_directories(${target_name}
    PUBLIC
        $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>
    PRIVATE
        ${opencv_INCLUDE_DIRS}
        ${PROJECT_SOURCE_DIR}/src/tensorrt
        ${CMAKE_CURRENT_BINARY_DIR}        # ?
        ${PROTO_SRC_DIRS}
        ${TENSORRT_DIR}/include
)

target_link_libraries(${target_name}
    PRIVATE
        ${opencv_LIBS}
        protobuf::libprotobuf
)

target_link_directories(${target_name}
    PRIVATE
        ${TENSORRT_DIR}/lib
)

set_target_properties(${target_name}
    PROPERTIES LINK_FLAGS "/ignore:4099"
    PROPERTIES CUDA_ARCHITECTURES 89-real 70-virtual
)

if(MSVC)
    target_compile_options(${target_name}
        PRIVATE
            $<$<COMPILE_LANGUAGE:CXX>: /W3 /wd4275 /wd4251 /wd4068 /wd4819 /wd4309 /wd4819>
    )
else()
    target_compile_options(${target_name}
        PRIVATE
            $<$<COMPILE_LANGUAGE:CXX>: -Wall -Wno-missing-braces>
    )
endif()

# this command would only set the minimum standard,
# i.e. CMake can still decide to use -std=c++17 instead
# if the given compilers support C++17
target_compile_features(${target_name} PRIVATE cuda_std_11)

set_target_properties(${target_name}
        PROPERTIES
                CUDA_RUNTIME_LIBRARY Shared
                # CUDA_STANDARD 14 # this one cannot be changed by CMake
                # CUDA_SEPARABLE_COMPILATION ON # not needed for this example
)

install(TARGETS ${target_name}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)

file(GLOB sdk_include_files
    ${PROJECT_SOURCE_DIR}/include/cuda_demo/cuda_demo.hpp
)
install(FILES ${sdk_include_files} DESTINATION include)

if(MSVC AND GENORATE_VS_DEBUG_INFORM)
    set_target_properties(${target_name} PROPERTIES LINK_FLAGS "/DEBUG")
    target_compile_options(${target_name}
    PRIVATE
        $<$<COMPILE_LANGUAGE:CXX>: /Zi>
    )
endif()
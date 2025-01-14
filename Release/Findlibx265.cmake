

function(conan_message MESSAGE_OUTPUT)
    if(NOT CONAN_CMAKE_SILENT_OUTPUT)
        message(${ARGV${0}})
    endif()
endfunction()


macro(conan_find_apple_frameworks FRAMEWORKS_FOUND FRAMEWORKS FRAMEWORKS_DIRS)
    if(APPLE)
        foreach(_FRAMEWORK ${FRAMEWORKS})
            # https://cmake.org/pipermail/cmake-developers/2017-August/030199.html
            find_library(CONAN_FRAMEWORK_${_FRAMEWORK}_FOUND NAMES ${_FRAMEWORK} PATHS ${FRAMEWORKS_DIRS} CMAKE_FIND_ROOT_PATH_BOTH)
            if(CONAN_FRAMEWORK_${_FRAMEWORK}_FOUND)
                list(APPEND ${FRAMEWORKS_FOUND} ${CONAN_FRAMEWORK_${_FRAMEWORK}_FOUND})
            else()
                message(FATAL_ERROR "Framework library ${_FRAMEWORK} not found in paths: ${FRAMEWORKS_DIRS}")
            endif()
        endforeach()
    endif()
endmacro()


function(conan_package_library_targets libraries package_libdir deps out_libraries out_libraries_target build_type package_name)
    unset(_CONAN_ACTUAL_TARGETS CACHE)
    unset(_CONAN_FOUND_SYSTEM_LIBS CACHE)
    foreach(_LIBRARY_NAME ${libraries})
        find_library(CONAN_FOUND_LIBRARY NAMES ${_LIBRARY_NAME} PATHS ${package_libdir}
                     NO_DEFAULT_PATH NO_CMAKE_FIND_ROOT_PATH)
        if(CONAN_FOUND_LIBRARY)
            conan_message(STATUS "Library ${_LIBRARY_NAME} found ${CONAN_FOUND_LIBRARY}")
            list(APPEND _out_libraries ${CONAN_FOUND_LIBRARY})
            if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
                # Create a micro-target for each lib/a found
                string(REGEX REPLACE "[^A-Za-z0-9.+_-]" "_" _LIBRARY_NAME ${_LIBRARY_NAME})
                set(_LIB_NAME CONAN_LIB::${package_name}_${_LIBRARY_NAME}${build_type})
                if(NOT TARGET ${_LIB_NAME})
                    # Create a micro-target for each lib/a found
                    add_library(${_LIB_NAME} UNKNOWN IMPORTED)
                    set_target_properties(${_LIB_NAME} PROPERTIES IMPORTED_LOCATION ${CONAN_FOUND_LIBRARY})
                    set(_CONAN_ACTUAL_TARGETS ${_CONAN_ACTUAL_TARGETS} ${_LIB_NAME})
                else()
                    conan_message(STATUS "Skipping already existing target: ${_LIB_NAME}")
                endif()
                list(APPEND _out_libraries_target ${_LIB_NAME})
            endif()
            conan_message(STATUS "Found: ${CONAN_FOUND_LIBRARY}")
        else()
            conan_message(STATUS "Library ${_LIBRARY_NAME} not found in package, might be system one")
            list(APPEND _out_libraries_target ${_LIBRARY_NAME})
            list(APPEND _out_libraries ${_LIBRARY_NAME})
            set(_CONAN_FOUND_SYSTEM_LIBS "${_CONAN_FOUND_SYSTEM_LIBS};${_LIBRARY_NAME}")
        endif()
        unset(CONAN_FOUND_LIBRARY CACHE)
    endforeach()

    if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
        # Add all dependencies to all targets
        string(REPLACE " " ";" deps_list "${deps}")
        foreach(_CONAN_ACTUAL_TARGET ${_CONAN_ACTUAL_TARGETS})
            set_property(TARGET ${_CONAN_ACTUAL_TARGET} PROPERTY INTERFACE_LINK_LIBRARIES "${_CONAN_FOUND_SYSTEM_LIBS};${deps_list}")
        endforeach()
    endif()

    set(${out_libraries} ${_out_libraries} PARENT_SCOPE)
    set(${out_libraries_target} ${_out_libraries_target} PARENT_SCOPE)
endfunction()


include(FindPackageHandleStandardArgs)

conan_message(STATUS "Conan: Using autogenerated Findlibx265.cmake")
# Global approach
set(libx265_FOUND 1)
set(libx265_VERSION "3.4")

find_package_handle_standard_args(libx265 REQUIRED_VARS
                                  libx265_VERSION VERSION_VAR libx265_VERSION)
mark_as_advanced(libx265_FOUND libx265_VERSION)


set(libx265_INCLUDE_DIRS "C:/Users/Administrator/.conan/data/libx265/3.4/_/_/package/2ca72a585dd183f359ae9a3a2ce113138e4cf427/include")
set(libx265_INCLUDE_DIR "C:/Users/Administrator/.conan/data/libx265/3.4/_/_/package/2ca72a585dd183f359ae9a3a2ce113138e4cf427/include")
set(libx265_INCLUDES "C:/Users/Administrator/.conan/data/libx265/3.4/_/_/package/2ca72a585dd183f359ae9a3a2ce113138e4cf427/include")
set(libx265_RES_DIRS )
set(libx265_DEFINITIONS )
set(libx265_LINKER_FLAGS_LIST
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>"
)
set(libx265_COMPILE_DEFINITIONS )
set(libx265_COMPILE_OPTIONS_LIST "" "")
set(libx265_COMPILE_OPTIONS_C "")
set(libx265_COMPILE_OPTIONS_CXX "")
set(libx265_LIBRARIES_TARGETS "") # Will be filled later, if CMake 3
set(libx265_LIBRARIES "") # Will be filled later
set(libx265_LIBS "") # Same as libx265_LIBRARIES
set(libx265_SYSTEM_LIBS )
set(libx265_FRAMEWORK_DIRS )
set(libx265_FRAMEWORKS )
set(libx265_FRAMEWORKS_FOUND "") # Will be filled later
set(libx265_BUILD_MODULES_PATHS )

conan_find_apple_frameworks(libx265_FRAMEWORKS_FOUND "${libx265_FRAMEWORKS}" "${libx265_FRAMEWORK_DIRS}")

mark_as_advanced(libx265_INCLUDE_DIRS
                 libx265_INCLUDE_DIR
                 libx265_INCLUDES
                 libx265_DEFINITIONS
                 libx265_LINKER_FLAGS_LIST
                 libx265_COMPILE_DEFINITIONS
                 libx265_COMPILE_OPTIONS_LIST
                 libx265_LIBRARIES
                 libx265_LIBS
                 libx265_LIBRARIES_TARGETS)

# Find the real .lib/.a and add them to libx265_LIBS and libx265_LIBRARY_LIST
set(libx265_LIBRARY_LIST x265)
set(libx265_LIB_DIRS "C:/Users/Administrator/.conan/data/libx265/3.4/_/_/package/2ca72a585dd183f359ae9a3a2ce113138e4cf427/lib")

# Gather all the libraries that should be linked to the targets (do not touch existing variables):
set(_libx265_DEPENDENCIES "${libx265_FRAMEWORKS_FOUND} ${libx265_SYSTEM_LIBS} ")

conan_package_library_targets("${libx265_LIBRARY_LIST}"  # libraries
                              "${libx265_LIB_DIRS}"      # package_libdir
                              "${_libx265_DEPENDENCIES}"  # deps
                              libx265_LIBRARIES            # out_libraries
                              libx265_LIBRARIES_TARGETS    # out_libraries_targets
                              ""                          # build_type
                              "libx265")                                      # package_name

set(libx265_LIBS ${libx265_LIBRARIES})

foreach(_FRAMEWORK ${libx265_FRAMEWORKS_FOUND})
    list(APPEND libx265_LIBRARIES_TARGETS ${_FRAMEWORK})
    list(APPEND libx265_LIBRARIES ${_FRAMEWORK})
endforeach()

foreach(_SYSTEM_LIB ${libx265_SYSTEM_LIBS})
    list(APPEND libx265_LIBRARIES_TARGETS ${_SYSTEM_LIB})
    list(APPEND libx265_LIBRARIES ${_SYSTEM_LIB})
endforeach()

# We need to add our requirements too
set(libx265_LIBRARIES_TARGETS "${libx265_LIBRARIES_TARGETS};")
set(libx265_LIBRARIES "${libx265_LIBRARIES};")

set(CMAKE_MODULE_PATH "C:/Users/Administrator/.conan/data/libx265/3.4/_/_/package/2ca72a585dd183f359ae9a3a2ce113138e4cf427/" ${CMAKE_MODULE_PATH})
set(CMAKE_PREFIX_PATH "C:/Users/Administrator/.conan/data/libx265/3.4/_/_/package/2ca72a585dd183f359ae9a3a2ce113138e4cf427/" ${CMAKE_PREFIX_PATH})

if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
    # Target approach
    if(NOT TARGET libx265::libx265)
        add_library(libx265::libx265 INTERFACE IMPORTED)
        if(libx265_INCLUDE_DIRS)
            set_target_properties(libx265::libx265 PROPERTIES INTERFACE_INCLUDE_DIRECTORIES
                                  "${libx265_INCLUDE_DIRS}")
        endif()
        set_property(TARGET libx265::libx265 PROPERTY INTERFACE_LINK_LIBRARIES
                     "${libx265_LIBRARIES_TARGETS};${libx265_LINKER_FLAGS_LIST}")
        set_property(TARGET libx265::libx265 PROPERTY INTERFACE_COMPILE_DEFINITIONS
                     ${libx265_COMPILE_DEFINITIONS})
        set_property(TARGET libx265::libx265 PROPERTY INTERFACE_COMPILE_OPTIONS
                     "${libx265_COMPILE_OPTIONS_LIST}")
        
    endif()
endif()

foreach(_BUILD_MODULE_PATH ${libx265_BUILD_MODULES_PATHS})
    include(${_BUILD_MODULE_PATH})
endforeach()

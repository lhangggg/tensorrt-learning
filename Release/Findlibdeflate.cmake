

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

conan_message(STATUS "Conan: Using autogenerated Findlibdeflate.cmake")
# Global approach
set(libdeflate_FOUND 1)
set(libdeflate_VERSION "1.9")

find_package_handle_standard_args(libdeflate REQUIRED_VARS
                                  libdeflate_VERSION VERSION_VAR libdeflate_VERSION)
mark_as_advanced(libdeflate_FOUND libdeflate_VERSION)


set(libdeflate_INCLUDE_DIRS "C:/Users/Administrator/.conan/data/libdeflate/1.9/_/_/package/3fb49604f9c2f729b85ba3115852006824e72cab/include")
set(libdeflate_INCLUDE_DIR "C:/Users/Administrator/.conan/data/libdeflate/1.9/_/_/package/3fb49604f9c2f729b85ba3115852006824e72cab/include")
set(libdeflate_INCLUDES "C:/Users/Administrator/.conan/data/libdeflate/1.9/_/_/package/3fb49604f9c2f729b85ba3115852006824e72cab/include")
set(libdeflate_RES_DIRS )
set(libdeflate_DEFINITIONS )
set(libdeflate_LINKER_FLAGS_LIST
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>"
)
set(libdeflate_COMPILE_DEFINITIONS )
set(libdeflate_COMPILE_OPTIONS_LIST "" "")
set(libdeflate_COMPILE_OPTIONS_C "")
set(libdeflate_COMPILE_OPTIONS_CXX "")
set(libdeflate_LIBRARIES_TARGETS "") # Will be filled later, if CMake 3
set(libdeflate_LIBRARIES "") # Will be filled later
set(libdeflate_LIBS "") # Same as libdeflate_LIBRARIES
set(libdeflate_SYSTEM_LIBS )
set(libdeflate_FRAMEWORK_DIRS )
set(libdeflate_FRAMEWORKS )
set(libdeflate_FRAMEWORKS_FOUND "") # Will be filled later
set(libdeflate_BUILD_MODULES_PATHS )

conan_find_apple_frameworks(libdeflate_FRAMEWORKS_FOUND "${libdeflate_FRAMEWORKS}" "${libdeflate_FRAMEWORK_DIRS}")

mark_as_advanced(libdeflate_INCLUDE_DIRS
                 libdeflate_INCLUDE_DIR
                 libdeflate_INCLUDES
                 libdeflate_DEFINITIONS
                 libdeflate_LINKER_FLAGS_LIST
                 libdeflate_COMPILE_DEFINITIONS
                 libdeflate_COMPILE_OPTIONS_LIST
                 libdeflate_LIBRARIES
                 libdeflate_LIBS
                 libdeflate_LIBRARIES_TARGETS)

# Find the real .lib/.a and add them to libdeflate_LIBS and libdeflate_LIBRARY_LIST
set(libdeflate_LIBRARY_LIST libdeflatestatic)
set(libdeflate_LIB_DIRS "C:/Users/Administrator/.conan/data/libdeflate/1.9/_/_/package/3fb49604f9c2f729b85ba3115852006824e72cab/lib")

# Gather all the libraries that should be linked to the targets (do not touch existing variables):
set(_libdeflate_DEPENDENCIES "${libdeflate_FRAMEWORKS_FOUND} ${libdeflate_SYSTEM_LIBS} ")

conan_package_library_targets("${libdeflate_LIBRARY_LIST}"  # libraries
                              "${libdeflate_LIB_DIRS}"      # package_libdir
                              "${_libdeflate_DEPENDENCIES}"  # deps
                              libdeflate_LIBRARIES            # out_libraries
                              libdeflate_LIBRARIES_TARGETS    # out_libraries_targets
                              ""                          # build_type
                              "libdeflate")                                      # package_name

set(libdeflate_LIBS ${libdeflate_LIBRARIES})

foreach(_FRAMEWORK ${libdeflate_FRAMEWORKS_FOUND})
    list(APPEND libdeflate_LIBRARIES_TARGETS ${_FRAMEWORK})
    list(APPEND libdeflate_LIBRARIES ${_FRAMEWORK})
endforeach()

foreach(_SYSTEM_LIB ${libdeflate_SYSTEM_LIBS})
    list(APPEND libdeflate_LIBRARIES_TARGETS ${_SYSTEM_LIB})
    list(APPEND libdeflate_LIBRARIES ${_SYSTEM_LIB})
endforeach()

# We need to add our requirements too
set(libdeflate_LIBRARIES_TARGETS "${libdeflate_LIBRARIES_TARGETS};")
set(libdeflate_LIBRARIES "${libdeflate_LIBRARIES};")

set(CMAKE_MODULE_PATH "C:/Users/Administrator/.conan/data/libdeflate/1.9/_/_/package/3fb49604f9c2f729b85ba3115852006824e72cab/" ${CMAKE_MODULE_PATH})
set(CMAKE_PREFIX_PATH "C:/Users/Administrator/.conan/data/libdeflate/1.9/_/_/package/3fb49604f9c2f729b85ba3115852006824e72cab/" ${CMAKE_PREFIX_PATH})

if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
    # Target approach
    if(NOT TARGET libdeflate::libdeflate)
        add_library(libdeflate::libdeflate INTERFACE IMPORTED)
        if(libdeflate_INCLUDE_DIRS)
            set_target_properties(libdeflate::libdeflate PROPERTIES INTERFACE_INCLUDE_DIRECTORIES
                                  "${libdeflate_INCLUDE_DIRS}")
        endif()
        set_property(TARGET libdeflate::libdeflate PROPERTY INTERFACE_LINK_LIBRARIES
                     "${libdeflate_LIBRARIES_TARGETS};${libdeflate_LINKER_FLAGS_LIST}")
        set_property(TARGET libdeflate::libdeflate PROPERTY INTERFACE_COMPILE_DEFINITIONS
                     ${libdeflate_COMPILE_DEFINITIONS})
        set_property(TARGET libdeflate::libdeflate PROPERTY INTERFACE_COMPILE_OPTIONS
                     "${libdeflate_COMPILE_OPTIONS_LIST}")
        
    endif()
endif()

foreach(_BUILD_MODULE_PATH ${libdeflate_BUILD_MODULES_PATHS})
    include(${_BUILD_MODULE_PATH})
endforeach()

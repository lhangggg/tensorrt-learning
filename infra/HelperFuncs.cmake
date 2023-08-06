# A helper function for adding applications for libraries.
function(add_app)
    cmake_parse_arguments(
        PARSED_ARGS # prefix of output variables
        "" # list of names of the boolean arguments (only defined ones will be true)
        "APP_NAME" # list of names of mono-valued arguments
        "APP_SRCS;APP_DEPS" # list of names of multi-valued arguments (output variables are lists)
        ${ARGN} # arguments of the function to parse, here we take the all original ones
    )
    add_executable(${PARSED_ARGS_APP_NAME})

    target_sources(${PARSED_ARGS_APP_NAME}
        PRIVATE
        ${PARSED_ARGS_APP_SRCS}
    )

    target_include_directories(${PARSED_ARGS_APP_NAME}
        PRIVATE
        ${OpenCV_INCLUDE_DIRS}
    )

    if(UNIX)
        target_link_libraries(${PARSED_ARGS_APP_NAME}
            PRIVATE
            ${PARSED_ARGS_APP_DEPS} "stdc++fs"
            ${OpenCV_LIBS}
        )
    else()
        target_link_libraries(${PARSED_ARGS_APP_NAME}
            PRIVATE
            ${PARSED_ARGS_APP_DEPS}
            ${OpenCV_LIBS}
        )

        if(GENORATE_VS_DEBUG_INFORM)
            set_target_properties(${PARSED_ARGS_APP_NAME} PROPERTIES VS_DEBUGGER_WORKING_DIRECTORY ${PROJECT_SOURCE_DIR})
            set_target_properties(${PARSED_ARGS_APP_NAME} PROPERTIES LINK_FLAGS "/DEBUG")
        endif()
    endif()

    add_test(${PARSED_ARGS_APP_NAME} ${PARSED_ARGS_APP_NAME})

    set_target_properties(${PARSED_ARGS_APP_NAME} PROPERTIES FOLDER "apps")

    install(
        TARGETS ${PARSED_ARGS_APP_NAME}
        RUNTIME DESTINATION ${CMAKE_INSTALL_PREFIX}/bin/apps
    )
    install(
        FILES ${PROJECT_SOURCE_DIR}/apps/${PARSED_ARGS_APP_SRCS}
        DESTINATION ${CMAKE_INSTALL_PREFIX}/bin/apps
    )
endfunction(add_app)

# A helper function for adding applications for libraries with cuda.
function(add_app_cuda)
    cmake_parse_arguments(
        PARSED_ARGS # prefix of output variables
        "" # list of names of the boolean arguments (only defined ones will be true)
        "APP_NAME" # list of names of mono-valued arguments
        "APP_SRCS; APP_DEPS" # list of names of multi-valued arguments (output variables are lists)
        ${ARGN} # arguments of the function to parse, here we take the all original ones
    )
    add_executable(${PARSED_ARGS_APP_NAME})

    target_sources(${PARSED_ARGS_APP_NAME}
        PRIVATE
            ${PARSED_ARGS_APP_SRCS}
    )

    target_include_directories(${PARSED_ARGS_APP_NAME}
        PRIVATE
            ${OpenCV_INCLUDE_DIRS}
    )

    if(UNIX)
        target_link_libraries(${PARSED_ARGS_APP_NAME}
            PRIVATE
                ${PARSED_ARGS_APP_DEPS} "stdc++fs"
                ${OpenCV_LIBS}
        )
    else()
        target_link_libraries(${PARSED_ARGS_APP_NAME}
            PRIVATE
                ${PARSED_ARGS_APP_DEPS}
                ${OpenCV_LIBS}
        )

        if(GENORATE_VS_DEBUG_INFORM)
            set_target_properties(${PARSED_ARGS_APP_NAME} PROPERTIES VS_DEBUGGER_WORKING_DIRECTORY ${PROJECT_SOURCE_DIR})
            set_target_properties(${PARSED_ARGS_APP_NAME} PROPERTIES LINK_FLAGS "/DEBUG")
        endif()
    endif()

    add_test(${PARSED_ARGS_APP_NAME} ${PARSED_ARGS_APP_NAME})

    set_target_properties(${PARSED_ARGS_APP_NAME} 
        PROPERTIES FOLDER "apps"
        PROPERTIES CUDA_ARCHITECTURES 89-real 70-virtual
    )

    # this command would only set the minimum standard,
    # i.e. CMake can still decide to use -std=c++17 instead
    # if the given compilers support C++17
    target_compile_features(${PARSED_ARGS_APP_NAME}  PRIVATE cuda_std_11)

    set_target_properties(${PARSED_ARGS_APP_NAME} 
        PROPERTIES
            CUDA_RUNTIME_LIBRARY Shared
            # CUDA_STANDARD 14 # this one cannot be changed by CMake
            # CUDA_SEPARABLE_COMPILATION ON # not needed for this example
    )

    install(TARGETS ${PARSED_ARGS_APP_NAME}
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
        LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
        ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    )

    # install(
    #     TARGETS ${PARSED_ARGS_APP_NAME}
    #     RUNTIME DESTINATION ${CMAKE_INSTALL_PREFIX}/bin/apps_cuda
    # )
endfunction(add_app_cuda)
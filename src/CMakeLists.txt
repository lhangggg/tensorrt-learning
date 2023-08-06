include(HelperFuncs)

#Add all modules 
# module list

set(MODULES
    "tensorrt"
    # "tutorial"
)

foreach(VAR ${MODULES})
	add_subdirectory(${VAR})
endforeach()

# install opencv dll in windows
if(MSVC)
    file(GLOB DllFiles
        ${OpenCV_DIR}/../bin/*.dll
    )

    foreach(DllFile ${DllFiles})
        add_custom_command(TARGET ${target_name} POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E
            copy ${DllFile} $<TARGET_FILE_DIR:${target_name}>
        )
    endforeach()
endif()
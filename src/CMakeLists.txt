include(HelperFuncs)

#Add all modules 
# module list

set(MODULES
    "core"
    "detection"
    "td_module"
)

foreach(VAR ${MODULES})
	add_subdirectory(${VAR})
endforeach()
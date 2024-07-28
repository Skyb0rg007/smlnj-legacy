
# Common build options for header file generators
add_library(gen-common EXCLUDE_FROM_ALL
    gen.h
    gen-common.c
)
target_include_directories(gen-common
    PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/../include
)
target_link_libraries(gen-common
    PUBLIC
    sml-runtime
)


# ml-regmask.h
add_executable(gen-regmask EXCLUDE_FROM_ALL
    gen-regmask.c
)
target_link_libraries(gen-regmask PRIVATE gen-common)
add_custom_command(
    OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/reg-mask.h"
    COMMAND $<TARGET_FILE:gen-regmask>
    WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
)


# ml-signals.h
add_executable(gen-signals EXCLUDE_FROM_ALL)
target_link_libraries(gen-signals PRIVATE gen-common)
if(UNIX)
    target_sources(gen-signals
        PRIVATE
        gen-unix-signals.h
        gen-unix-signals.c
        unix-signals.c
    )
elseif(WIN32)
    target_sources(gen-signals
        PRIVATE
        gen-win32-signals.c
        win32-signals.c
    )
else()
    message(FATAL_ERROR "Not implemented")
endif()
add_custom_command(
    OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/system-signals.h"
    COMMAND $<TARGET_FILE:gen-signals>
    WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
)


# ml-sizes.h
add_executable(gen-sizes EXCLUDE_FROM_ALL
    gen-sizes.c
)
target_link_libraries(gen-sizes PRIVATE gen-common)
add_custom_command(
    OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/ml-sizes.h"
    COMMAND $<TARGET_FILE:gen-sizes>
    WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
)


# mlstate-offsets.h
add_executable(gen-offsets EXCLUDE_FROM_ALL
    ${CMAKE_CURRENT_BINARY_DIR}/ml-sizes.h
    ${CMAKE_CURRENT_BINARY_DIR}/system-signals.h
    gen-offsets.c
)
target_link_libraries(gen-offsets PRIVATE gen-common)
target_include_directories(gen-offsets
    PRIVATE
    ${CMAKE_CURRENT_BINARY_DIR}
)
add_custom_command(
    OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/mlstate-offsets.h"
    COMMAND $<TARGET_FILE:gen-offsets>
    WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
)


# unix-sigtbl.c / win32-sigtbl.c
add_executable(gen-sigtbl EXCLUDE_FROM_ALL)
target_link_libraries(gen-sigtbl PRIVATE gen-common)
if(UNIX)
    target_sources(gen-sigtbl
        PRIVATE
        gen-unix-sigtbl.c
        unix-signals.c
    )
    set(sigtbl_source "unix-sigtbl.c")
elseif(WIN32)
    target_sources(gen-sigtbl
        PRIVATE
        gen-win32-sigtbl.c
        win32-signals.c
    )
    set(sigtbl_source "win32-sigtbl.c")
else()
    message(FATAL_ERROR "Not implemented")
endif()
add_custom_command(
    OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/${sigtbl_source}"
    COMMAND $<TARGET_FILE:gen-sigtbl>
    WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
)
# Make the sigtbl.c file a header file to prevent compilation
set_source_files_properties(
    ${CMAKE_CURRENT_BINARY_DIR}/${sigtbl_source}
    DIRECTORY ${CMAKE_SOURCE_DIR}
    PROPERTIES HEADER_FILE_ONLY ON
)

# Library that includes all of the generated headers
add_library(runtime-generated INTERFACE
    ${CMAKE_CURRENT_BINARY_DIR}/ml-sizes.h
    ${CMAKE_CURRENT_BINARY_DIR}/mlstate-offsets.h
    ${CMAKE_CURRENT_BINARY_DIR}/reg-mask.h
    ${CMAKE_CURRENT_BINARY_DIR}/system-signals.h
    ${CMAKE_CURRENT_BINARY_DIR}/${sigtbl_source}
)
target_include_directories(runtime-generated
    INTERFACE
    ${CMAKE_CURRENT_BINARY_DIR}
)

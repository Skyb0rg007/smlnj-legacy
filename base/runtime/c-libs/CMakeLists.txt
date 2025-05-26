## base/runtime/c-libs/CMakeLists.txt
##
## COPYRIGHT (c) 2025 Skye Soss
## All rights reserved.
##
## Defines the following public CMake targets:
## - sml-clibraries
##     Object library that includes all the SML libraries defined in C
##
## The following CMake targets should not be referenced outside this file:
## - sml-clibs
##     Interface library used for common settings across C libraries

add_library(sml-clibs INTERFACE)
target_link_libraries(sml-clibs
    INTERFACE
    sml-runtime
    runtime-generated
)
target_include_directories(sml-clibs
    INTERFACE
    ${CMAKE_CURRENT_SOURCE_DIR}
)

add_subdirectory(posix-os)      # posix-os
add_subdirectory(smlnj-runtime) # smlnj-runt
add_subdirectory(smlnj-signals) # smlnj-sig
add_subdirectory(smlnj-sockets) # smlnj-sock
add_subdirectory(smlnj-prof)    # smlnj-prof
add_subdirectory(smlnj-time)    # smlnj-time
add_subdirectory(smlnj-date)    # smlnj-date
add_subdirectory(smlnj-math)    # smlnj-math
add_subdirectory(smlnj-mp)      # smlnj-mp (ERROR)
add_subdirectory(smlnj-ccalls)  # smlnj-ccalls (ERROR)
add_subdirectory(dl)            # unix-dynload
if(UNIX)
    add_subdirectory(posix-error)   # posix-error
    add_subdirectory(posix-filesys) # posix-filesys
    add_subdirectory(posix-io)      # posix-io
    add_subdirectory(posix-procenv) # posix-procenv
    add_subdirectory(posix-process) # posix-process
    add_subdirectory(posix-signal)  # posix-signal
    add_subdirectory(posix-sysdb)   # posix-sysdb
    add_subdirectory(posix-tty)     # posix-tty
elseif(WIN32)
    add_subdirectory(win32)         # sml-win32
    add_subdirectory(win32-io)      # sml-win32-io
    add_subdirectory(win32-filesys) # sml-win32-filesys
    add_subdirectory(win32-process) # sml-win32-process
endif()

add_library(sml-clibraries OBJECT
    clib-list.h
    c-libraries.c
    unix-raise-syserr.c
)
target_link_libraries(sml-clibraries
    PRIVATE
    PUBLIC
    sml-clibs
    smlnj-prof
    smlnj-time
    smlnj-date
    smlnj-runt
    smlnj-sig
    smlnj-sock
    smlnj-math
)

if(UNIX)
    target_link_libraries(sml-clibraries
        PUBLIC
        posix-os
        posix-io
        posix-filesys
        posix-procenv
        posix-process
        posix-sysdb
        posix-signal
        posix-tty
        posix-error
        unix-dynload
    )
elseif(WIN32)
    target_link_libraries(sml-clibraries
        PUBLIC
        sml-win32
        sml-win32-io
        sml-win32-filesys
        sml-win32-process
    )
endif()

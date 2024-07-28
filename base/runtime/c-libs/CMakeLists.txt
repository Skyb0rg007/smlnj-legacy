
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

add_subdirectory(posix-os)
add_subdirectory(smlnj-runtime)
add_subdirectory(smlnj-signals)
add_subdirectory(smlnj-sockets)
add_subdirectory(smlnj-prof)
add_subdirectory(smlnj-time)
add_subdirectory(smlnj-date)
add_subdirectory(smlnj-math)
add_subdirectory(smlnj-mp)
add_subdirectory(smlnj-ccalls)
add_subdirectory(dl)
if(UNIX)
    add_subdirectory(posix-error)
    add_subdirectory(posix-filesys)
    add_subdirectory(posix-io)
    add_subdirectory(posix-procenv)
    add_subdirectory(posix-process)
    add_subdirectory(posix-signal)
    add_subdirectory(posix-sysdb)
    add_subdirectory(posix-tty)
endif()

add_library(sml-clibraries STATIC
    clib-list.h

    c-libraries.c
    unix-raise-syserr.c
)
target_link_libraries(sml-clibraries
    PRIVATE
    sml-clibs
    PUBLIC
    smlnj-prof
    smlnj-time
    smlnj-date
    smlnj-runt
    smlnj-sig
    smlnj-sock
    smlnj-math

    # TODO: Only on UNIX
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


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
# add_subdirectory(smlnj-mp)      # smlnj-mp
# add_subdirectory(smlnj-ccalls)  # smlnj-ccalls
add_subdirectory(dl)            # unix-dynload
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
endif()

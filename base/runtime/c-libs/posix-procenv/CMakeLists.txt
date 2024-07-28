
add_library(posix-procenv STATIC
    cfun-list.h
    cfun-proto-list.h
    ${CMAKE_CURRENT_BINARY_DIR}/ml_sysconf.h

    ctermid.c
    environ.c
    getegid.c
    getenv.c
    geteuid.c
    getgid.c
    getgroups.c
    getlogin.c
    getpgrp.c
    getpid.c
    getppid.c
    getuid.c
    isatty.c
    posix-procenv-lib.c
    setgid.c
    setpgid.c
    setsid.c
    setuid.c
    sysconf.c
    time.c
    times.c
    ttyname.c
    uname.c
)
target_link_libraries(posix-procenv
    PRIVATE
    sml-clibs
)
target_include_directories(posix-procenv
    PRIVATE
    ${CMAKE_CURRENT_BINARY_DIR}
)

add_custom_command(
    OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/ml_sysconf.h"
    COMMAND
    ${CMAKE_COMMAND} -E env VERSION=${PROJECT_VERSION}
    ${CMAKE_CURRENT_SOURCE_DIR}/../../config/gen-posix-names.sh _SC_ ml_sysconf.h
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
)


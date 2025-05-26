## base/runtime/c-libs/posix-process/CMakeLists.txt
##
## COPYRIGHT (c) 2025 Skye Soss
## All rights reserved.
##
## Defines the following public CMake targets:
## - posix-process
##     SML/NJ C library that defines process functions like `exec` and `kill`

add_library(posix-process STATIC
    cfun-list.h
    cfun-proto-list.h

    alarm.c
    exec.c
    exece.c
    execp.c
    exit.c
    fork.c
    kill.c
    osval.c
    pause.c
    posix-process-lib.c
    sleep.c
    waitpid.c
)
target_link_libraries(posix-process
    PRIVATE
    sml-clibs
)

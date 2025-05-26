## base/runtime/c-libs/posix-tty/CMakeLists.txt
##
## COPYRIGHT (c) 2025 Skye Soss
## All rights reserved.
##
## Defines the following public CMake targets:
## - posix-tty
##     SML/NJ C library that defines tty functions

add_library(posix-tty STATIC
    cfun-list.h
    cfun-proto-list.h

    getwinsz.c
    osval.c
    posix-tty-lib.c
    tcdrain.c
    tcflow.c
    tcflush.c
    tcgetattr.c
    tcgetpgrp.c
    tcsendbreak.c
    tcsetattr.c
    tcsetpgrp.c
)
target_link_libraries(posix-tty
    PRIVATE
    sml-clibs
)

## base/runtime/c-libs/posix-os/CMakeLists.txt
##
## COPYRIGHT (c) 2025 Skye Soss
## All rights reserved.
##
## Defines the following public CMake targets:
## - posix-os
##     SML/NJ C library that defines `poll` and `tmpname`

add_library(posix-os STATIC
    cfun-list.h
    cfun-proto-list.h
    poll.c
    posix-os-lib.c
    tmpname.c
)
target_link_libraries(posix-os
    PRIVATE
    sml-clibs
)

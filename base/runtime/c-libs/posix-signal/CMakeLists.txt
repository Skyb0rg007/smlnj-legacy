## base/runtime/c-libs/posix-signal/CMakeLists.txt
##
## COPYRIGHT (c) 2025 Skye Soss
## All rights reserved.
##
## Defines the following public CMake targets:
## - posix-signal
##     SML/NJ C library that defines `osval` to convert signal names to numbers

add_library(posix-signal STATIC
    cfun-list.h
    cfun-proto-list.h

    osval.c
    posix-signal-lib.c
)
target_link_libraries(posix-signal
    PRIVATE
    sml-clibs
)

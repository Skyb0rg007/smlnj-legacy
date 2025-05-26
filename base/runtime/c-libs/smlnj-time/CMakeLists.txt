## base/runtime/c-libs/smlnj-time/CMakeLists.txt
##
## COPYRIGHT (c) 2025 Skye Soss
## All rights reserved.
##
## Defines the following public CMake targets:
## - smlnj-time
##     SML/NJ C library that defines time functions

add_library(smlnj-time STATIC
    cfun-proto-list.h
    cfun-list.h

    gettime.c
    timeofday.c
    smlnj-time-lib.c
)
target_link_libraries(smlnj-time
    PRIVATE
    sml-clibs
)

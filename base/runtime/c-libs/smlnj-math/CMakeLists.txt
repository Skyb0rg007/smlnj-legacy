## base/runtime/c-libs/smlnj-math/CMakeLists.txt
##
## COPYRIGHT (c) 2025 Skye Soss
## All rights reserved.
##
## Defines the following public CMake targets:
## - smlnj-math
##     SML/NJ C library that defines math functions

add_library(smlnj-math STATIC
    cfun-proto-list.h
    cfun-list.h
    fp-dep.h

    ctlrndmode.c
    atan64.c
    cos64.c
    exp64.c
    log64.c
    sin64.c
    sqrt64.c
    smlnj-math-lib.c
)
target_link_libraries(smlnj-math
    PRIVATE
    sml-clibs
    m
)

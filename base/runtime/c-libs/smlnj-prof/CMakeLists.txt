## base/runtime/c-libs/smlnj-prof/CMakeLists.txt
##
## COPYRIGHT (c) 2025 Skye Soss
## All rights reserved.
##
## Defines the following public CMake targets:
## - smlnj-prof
##     SML/NJ C library that defines timer functions (for profiling)

add_library(smlnj-prof STATIC
    cfun-proto-list.h
    cfun-list.h

    smlnj-prof-lib.c
    getpquantum.c
    setpref.c
    setptimer.c
)
target_link_libraries(smlnj-prof
    PRIVATE
    sml-clibs
    mach-dep
)

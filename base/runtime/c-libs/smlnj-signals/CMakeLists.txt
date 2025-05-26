## base/runtime/c-libs/smlnj-signals/CMakeLists.txt
##
## COPYRIGHT (c) 2025 Skye Soss
## All rights reserved.
##
## Defines the following public CMake targets:
## - smlnj-sig
##     SML/NJ C library that defines signal functions

add_library(smlnj-sig STATIC
    cfun-list.h
    cfun-proto-list.h
    getsigmask.c
    getsigstate.c
    listsignals.c
    pause.c
    setsigmask.c
    setsigstate.c
    smlnj-sig-lib.c
)
target_link_libraries(smlnj-sig
    PRIVATE
    sml-clibs
    mach-dep
)

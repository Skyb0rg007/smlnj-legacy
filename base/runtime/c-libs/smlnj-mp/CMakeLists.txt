## base/runtime/c-libs/smlnj-mp/CMakeLists.txt
##
## COPYRIGHT (c) 2025 Skye Soss
## All rights reserved.
##
## Defines the following public CMake targets:
## - smlnj-mp
##     SML/NJ C library that defines multi-processor functions
##
## Note: This library is defunct

add_library(smlnj-mp EXCLUDE_FROM_ALL STATIC
    cfun-proto-list.h
    cfun-list.h

    acquire-proc.c
    max-procs.c
    release-proc.c
    spin-lock.c
    libsmlnj-mp.c
)
target_link_libraries(smlnj-mp
    PRIVATE
    sml-clibs
)

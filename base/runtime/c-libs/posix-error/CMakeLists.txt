## base/runtime/c-libs/posix-error/CMakeLists.txt
##
## COPYRIGHT (c) 2025 Skye Soss
## All rights reserved.
##
## Defines the following public CMake targets:
## - posix-error
##     SML/NJ C library that defines functions to handle POSIX error codes

add_library(posix-error STATIC
    cfun-proto-list.h
    cfun-list.h

    posix-error-lib.c
    posix-name-val.c
    errmsg.c
    geterror.c
    listerrors.c
    tbl-errno.c
)
target_link_libraries(posix-error
    PRIVATE
    sml-clibs
)

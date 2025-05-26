## base/runtime/c-libs/smlnj-date/CMakeLists.txt
##
## COPYRIGHT (c) 2025 Skye Soss
## All rights reserved.
##
## Defines the following public CMake targets:
## - smlnj-date
##     SML/NJ C library that defines date functions

add_library(smlnj-date STATIC
    cfun-proto-list.h
    cfun-list.h

    gmtime.c
    localoffset.c
    localtime.c
    mktime.c
    strftime.c
    unix-date.c
    smlnj-date-lib.c
)
target_link_libraries(smlnj-date
    PRIVATE
    sml-clibs
)

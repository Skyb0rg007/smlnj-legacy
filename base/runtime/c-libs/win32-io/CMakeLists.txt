## base/runtime/c-libs/win32-io/CMakeLists.txt
##
## COPYRIGHT (c) 2025 Skye Soss
## All rights reserved.
##
## Defines the following public CMake targets:
## - sml-win32-io
##     SML/NJ C library that defines functions for the Win32 IO library

add_library(sml-win32-io STATIC
    cfun-list.h
    cfun-proto-list.h

    win32-io-lib.c
    win32-io.c
    poll.c
)
target_link_libraries(smlnj-win32-io
    PRIVATE
    sml-clibs
)


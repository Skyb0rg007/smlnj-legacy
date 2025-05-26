## base/runtime/c-libs/win32/CMakeLists.txt
##
## COPYRIGHT (c) 2025 Skye Soss
## All rights reserved.
##
## Defines the following public CMake targets:
## - sml-win32
##     SML/NJ C library that defines Win32 API functions

add_library(sml-win32 STATIC
    cfun-list.h
    cfun-proto-list.h
    name-val.h

    win32-lib.c
    win32-constants.c
    win32-errors.c
    win32-dde.c
    win32-reg.c
    win32-config.c
    name-val.c
)
target_link_libraries(smlnj-win32
    PRIVATE
    sml-clibs
)


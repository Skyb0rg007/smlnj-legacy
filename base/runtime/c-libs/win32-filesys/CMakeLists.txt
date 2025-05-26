## base/runtime/c-libs/win32-filesys/CMakeLists.txt
##
## COPYRIGHT (c) 2025 Skye Soss
## All rights reserved.
##
## Defines the following public CMake targets:
## - sml-win32-filesys
##     SML/NJ C library for the Win32 filesystem library

add_library(sml-win32-filesys STATIC
    cfun-proto-list.h
    cfun-list.h

    win32-filesys-lib.c
    win32-filesys.c
)
target_link_libraries(sml-win32-filesys
    PRIVATE
    sml-clibs
)


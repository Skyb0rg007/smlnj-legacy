## base/runtime/c-libs/win32-process/CMakeLists.txt
##
## COPYRIGHT (c) 2025 Skye Soss
## All rights reserved.
##
## Defines the following public CMake targets:
## - sml-win32-process
##     SML/NJ C library for the Win32 process library

add_library(sml-win32-process STATIC
    cfun-proto-list.h
    cfun-list.h

    win32-process-lib.c
    win32-process.c
)
target_link_libraries(sml-win32-process
    PRIVATE
    sml-clibs
)


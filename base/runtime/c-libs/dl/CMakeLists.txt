## base/runtime/c-libs/dl/CMakeLists.txt
##
## COPYRIGHT (c) 2025 Skye Soss
## All rights reserved.
##
## Defines the following public CMake targets:
## - unix-dynload
##     SML/NJ C library that defines dynamic symbol loading

add_library(unix-dynload STATIC
    cfun-list.h
    cfun-proto-list.h

    dlclose.c
    dlerror.c
    dlopen.c
    dlsym.c
    # Despite the name, this compiles on Windows as well
    unix-dynload-lib.c
)
target_link_libraries(unix-dynload
    PRIVATE
    sml-clibs
)

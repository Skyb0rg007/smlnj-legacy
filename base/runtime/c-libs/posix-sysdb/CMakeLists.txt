## base/runtime/c-libs/posix-sysdb/CMakeLists.txt
##
## COPYRIGHT (c) 2025 Skye Soss
## All rights reserved.
##
## Defines the following public CMake targets:
## - posix-sysdb
##     SML/NJ C library that defines functions to access the password database

add_library(posix-sysdb STATIC
    cfun-list.h
    cfun-proto-list.h

    getgrgid.c
    getgrnam.c
    getpwnam.c
    getpwuid.c
    posix-sysdb-lib.c
)
target_link_libraries(posix-sysdb
    PRIVATE
    sml-clibs
)

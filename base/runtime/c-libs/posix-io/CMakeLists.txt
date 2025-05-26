## base/runtime/c-libs/posix-io/CMakeLists.txt
##
## COPYRIGHT (c) 2025 Skye Soss
## All rights reserved.
##
## Defines the following public CMake targets:
## - posix-io
##     SML/NJ C library that defines I/O functions

add_library(posix-io STATIC
    cfun-list.h
    cfun-proto-list.h

    posix-io-lib.c
    osval.c
    pipe.c
    dup.c
    dup2.c
    close.c
    read.c
    readbuf.c
    write.c
    writebuf.c
    fcntl_d.c
    fcntl_gfd.c
    fcntl_sfd.c
    fcntl_gfl.c
    fcntl_sfl.c
    fcntl_l.c
    lseek.c
    fsync.c
)
target_link_libraries(posix-io
    PRIVATE
    sml-clibs
)

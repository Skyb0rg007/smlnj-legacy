## base/runtime/c-libs/smlnj-runtime/CMakeLists.txt
##
## COPYRIGHT (c) 2025 Skye Soss
## All rights reserved.
##
## Defines the following public CMake targets:
## - smlnj-runt
##     SML/NJ C library that defines utilities like `argv` and `setIntTimer`

add_library(smlnj-runt STATIC
    cfun-list.h
    cfun-proto-list.h
    alloc-code.c
    argv.c
    blast-in.c
    blast-out.c
    cmd-name.c
    debug.c
    dummy.c
    export-fun.c
    export-heap.c
    gc-counter.c
    gc-ctl.c
    itick.c
    mkexec.c
    mkliterals.c
    raw-argv.c
    record-concat.c
    record1.c
    setitimer.c
    shift-argv.c
    smlnj-runt-lib.c
    sysinfo.c
)
target_link_libraries(smlnj-runt
    PRIVATE
    sml-clibs
    gc
)


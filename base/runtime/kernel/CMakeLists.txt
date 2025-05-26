## base/runtime/kernel/CMakeLists.txt
##
## COPYRIGHT (c) 2025 Skye Soss
## All rights reserved.
##
## Defines the following public CMake targets:
## - kernel
##     The SML/NJ runtime executable

add_executable(kernel
    bill-os.c
    boot.c
    error.c
    globals.c
    load-ml.c
    main.c
    ml-options.c
    ml-state.c
    qualify-name.c
    run-ml.c
    swap-bytes.c
    timers.c
    unix-timers.c
    # standalone.c
)
target_link_libraries(kernel
    PUBLIC
    sml-runtime
    runtime-generated

    gc
    mem
    mach-dep
    sml-prim
    sml-clibraries
    sml-clibs
)


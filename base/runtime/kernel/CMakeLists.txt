
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
)


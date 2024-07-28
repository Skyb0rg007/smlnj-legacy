
add_library(smlnj-runt STATIC
    cfun-proto-list.h
    cfun-list.h
    smlnj-runt-lib.c
    alloc-code.c
    argv.c
    raw-argv.c
    shift-argv.c
    cmd-name.c
    blast-in.c
    blast-out.c
    debug.c
    dummy.c
    export-heap.c
    export-fun.c
    gc-ctl.c
    itick.c
    mkexec.c
    mkliterals.c
    record1.c
    record-concat.c
    sysinfo.c
    setitimer.c
)
target_link_libraries(smlnj-runt
    PRIVATE
    sml-clibs
    gc
)



add_library(smlnj-prof STATIC
    cfun-proto-list.h
    cfun-list.h

    smlnj-prof-lib.c
    getpquantum.c
    setpref.c
    setptimer.c
)
target_link_libraries(smlnj-prof
    PRIVATE
    sml-clibs
    mach-dep
)


add_library(smlnj-sig STATIC
    cfun-proto-list.h
    cfun-list.h
    getsigmask.c
    getsigstate.c
    listsignals.c
    pause.c
    setsigmask.c
    setsigstate.c
    smlnj-sig-lib.c
)
target_link_libraries(smlnj-sig
    PRIVATE
    sml-clibs
)

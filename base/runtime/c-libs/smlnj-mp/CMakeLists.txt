
add_library(smlnj-mp STATIC
    cfun-proto-list.h
    cfun-list.h

    acquire-proc.c
    max-procs.c
    release-proc.c
    spin-lock.c
    libsmlnj-mp.c
)
target_link_libraries(smlnj-mp
    PRIVATE
    sml-clibs
)

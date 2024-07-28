
add_library(posix-error STATIC
    cfun-proto-list.h
    cfun-list.h

    posix-error-lib.c
    posix-name-val.c
    errmsg.c
    geterror.c
    listerrors.c
    tbl-errno.c
)
target_link_libraries(posix-error
    PRIVATE
    sml-clibs
)

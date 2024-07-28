
add_library(posix-signal STATIC
    cfun-list.h
    cfun-proto-list.h

    osval.c
    posix-signal-lib.c
)
target_link_libraries(posix-signal
    PRIVATE
    sml-clibs
)

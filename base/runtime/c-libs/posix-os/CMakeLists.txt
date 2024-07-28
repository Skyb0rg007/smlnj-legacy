
add_library(posix-os STATIC
    cfun-proto-list.h
    cfun-list.h
    posix-os-lib.c
    poll.c
    tmpname.c
)
target_link_libraries(posix-os
    PRIVATE
    sml-clibs
)

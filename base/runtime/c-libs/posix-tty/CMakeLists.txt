
add_library(posix-tty STATIC
    cfun-list.h
    cfun-proto-list.h

    getwinsz.c
    osval.c
    posix-tty-lib.c
    tcdrain.c
    tcflow.c
    tcflush.c
    tcgetattr.c
    tcgetpgrp.c
    tcsendbreak.c
    tcsetattr.c
    tcsetpgrp.c
)
target_link_libraries(posix-tty
    PRIVATE
    sml-clibs
)

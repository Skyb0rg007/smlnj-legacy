
add_library(posix-process STATIC
    cfun-list.h
    cfun-proto-list.h

    alarm.c
    exec.c
    exece.c
    execp.c
    exit.c
    fork.c
    kill.c
    osval.c
    pause.c
    posix-process-lib.c
    sleep.c
    waitpid.c
)
target_link_libraries(posix-process
    PRIVATE
    sml-clibs
)

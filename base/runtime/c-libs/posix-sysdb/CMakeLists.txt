
add_library(posix-sysdb STATIC
    cfun-list.h
    cfun-proto-list.h

    getgrgid.c
    getgrnam.c
    getpwnam.c
    getpwuid.c
    posix-sysdb-lib.c
)
target_link_libraries(posix-sysdb
    PRIVATE
    sml-clibs
)

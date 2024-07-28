
add_library(unix-dynload STATIC
    cfun-list.h
    cfun-proto-list.h

    dlclose.c
    dlerror.c
    dlopen.c
    dlsym.c
    unix-dynload-lib.c
)
target_link_libraries(unix-dynload
    PRIVATE
    sml-clibs
)

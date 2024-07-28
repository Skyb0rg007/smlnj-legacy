
add_library(smlnj-time STATIC
    cfun-proto-list.h
    cfun-list.h

    gettime.c
    timeofday.c
    smlnj-time-lib.c
)
target_link_libraries(smlnj-time
    PRIVATE
    sml-clibs
)

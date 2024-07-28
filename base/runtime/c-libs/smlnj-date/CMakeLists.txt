
add_library(smlnj-date STATIC
    cfun-proto-list.h
    cfun-list.h

    gmtime.c
    localoffset.c
    localtime.c
    mktime.c
    strftime.c
    unix-date.c
    smlnj-date-lib.c
)
target_link_libraries(smlnj-date
    PRIVATE
    sml-clibs
)


add_library(mp STATIC
    sgi-mp.c)

target_link_libraries(mp PRIVATE sml-runtime)


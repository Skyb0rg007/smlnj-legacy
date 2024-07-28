
add_library(gc STATIC
    heap.h

    addr-hash.c
    big-objects.c
    blast-gc.c
    blast-in.c
    blast-out.c
    build-literals.c
    c-globals-tbl.c
    call-gc.c
    export-heap.c
    flip.c
    gc-util.c
    heap-in-util.c
    heap-out-util.c
    import-heap.c
    init-gc.c
    major-gc.c
    mem-writer.c
    minor-gc.c
    ml-objects.c
    obj-info.c
    old-literals.c
    record-ops.c
    writer.c
    # gc-stats.c
    # mp-gc.c
)

target_include_directories(gc
    PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
)

if(CHECK_HEAP)
    target_sources(gc check-heap.c)
endif()

target_link_libraries(gc PRIVATE sml-runtime runtime-generated)

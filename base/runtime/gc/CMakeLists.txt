## base/runtime/gc/CMakeLists.txt
##
## COPYRIGHT (c) 2025 Skye Soss
## All rights reserved.
##
## Defines the following public CMake targets:
## - gc
##     SML/NJ garbage collection implementation

add_library(gc STATIC
    addr-hash.h
    card-map.h
    heap-input.h
    heap.h
    arena-id.h
    copy-loop.h
    heap-monitor.h
    ml-heap-image.h
    blast-out.h
    gc-stats.h
    heap-output.h
    writer.h


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
    gc-stats.c
    gc-util.c
    heap-in-util.c
    heap-out-util.c
    import-heap.c
    init-gc.c
    init-gc.c
    major-gc.c
    mem-writer.c
    minor-gc.c
    ml-objects.c
    obj-info.c
    old-literals.c
    record-ops.c
    writer.c
    # mp-gc.c
)
target_include_directories(gc
    PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
)
target_link_libraries(gc
    PRIVATE
    sml-runtime
    runtime-generated
)

if(CHECK_HEAP)
    target_sources(gc check-heap.c)
endif()


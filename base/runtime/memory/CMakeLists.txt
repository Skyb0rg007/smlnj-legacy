
add_library(mem STATIC)

target_link_libraries(mem
    PRIVATE
    sml-runtime
    runtime-generated
)

if(WIN32)
    target_sources(mem PRIVATE mem-win32.c)
elseif(MEMORY_MACH)
    target_sources(mem PRIVATE mem-mach.c)
else()
    target_sources(mem PRIVATE mem-mmap.c)
endif()

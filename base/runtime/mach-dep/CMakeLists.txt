
add_library(mach-dep STATIC
    signal-sysdep.h

    signal-util.c
)
if(UNIX)
    target_sources(mach-dep
        PRIVATE
        unix-fault.c
        unix-signal.c
        unix-prof.c
    )
elseif(WIN32)
    target_sources(mach-dep
        PRIVATE
        win32-fault.h
        win32-fault.c
        win32-signal.c
        win32-timers.c
    )
endif()
target_link_libraries(mach-dep
    PRIVATE
    sml-runtime
    runtime-generated
)

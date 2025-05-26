## base/runtime/mach-dep/CMakeLists.txt
##
## COPYRIGHT (c) 2025 Skye Soss
## All rights reserved.
##
## Defines the following public CMake targets:
## - mach-dep
##     OS-specific implementation of signals and other system components
## - sml-prim
##     Processor-specific assembly instructions

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

# Ensure the *.prim.asm files are properly compiled
set_source_files_properties(
    AMD64.prim.asm
    PPC.prim.asm
    SPARC.prim.asm
    x86.prim.asm
    PROPERTIES
    LANGUAGE ASM
    COMPILE_DEFINITIONS _ASM_
    COMPILE_OPTIONS "-x;assembler-with-cpp"
)

# sml-prim - primitive operations
string(TOUPPER "${SML_ARCH}" target)
add_library(sml-prim OBJECT
    ${target}.prim.asm
)
target_link_libraries(sml-prim
    PRIVATE
    sml-runtime
    sml-clibraries
    runtime-generated
)


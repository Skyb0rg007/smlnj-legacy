## base/runtime/CMakeLists.txt
##
## COPYRIGHT (c) 2025 Skye Soss
## All rights reserved.
##
## Defines the following public CMake targets:
## - sml-runtime
##     Interface library that adds the project's include directory to the
##     search path and sets the C language version to C99.
##     Compiler and linker flags for optimization and warnings are added here.
## - sml-prim
##     Platform-specific assembly code for primitive operations

# sml-runtime - a target for defines
add_library(sml-runtime INTERFACE)
target_include_directories(sml-runtime
    INTERFACE
    include
)
target_compile_features(sml-runtime
    INTERFACE
    c_std_99
)
# TODO: determine these programatically
target_compile_definitions(sml-runtime
    INTERFACE
        OPSYS_UNIX
        OPSYS_LINUX
        ARCH_AMD64
        SIZE_64
        GNU_ASSEMBLER
        DLOPEN
        INDIRECT_CFUNC
        _GNU_SOURCE
)
target_compile_options(sml-runtime
    INTERFACE
        # -Wall
        # -O2
)

add_subdirectory(config)
add_subdirectory(memory)
add_subdirectory(c-libs)
add_subdirectory(gc)
# add_subdirectory(mp)
add_subdirectory(mach-dep)
add_subdirectory(kernel)


## base/runtime/c-libs/smlnj-ccalls/CMakeLists.txt
##
## COPYRIGHT (c) 2025 Skye Soss
## All rights reserved.
##
## Defines the following public CMake targets:
## - smlnj-ccalls
##     SML/NJ C library that defines functions for making FFI calls
##
## Note: This library does not compile

add_library(smlnj-ccalls EXCLUDE_FROM_ALL STATIC
    cfun-list.h
    cfun-proto-list.h
    c-calls.h

    c-calls-fns.c
    c-calls-lib.c
    c-calls.c
    cutil.c
    c-entry.asm
)
set_source_files_properties(
    c-entry.asm
    PROPERTIES COMPILE_DEFINITIONS _ASM_
)
target_link_libraries(smlnj-ccalls
    PRIVATE
    sml-clibs
)
